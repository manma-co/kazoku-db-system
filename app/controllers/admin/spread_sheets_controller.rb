# スプレッドシートからユーザ情報を取得するためのコントローラ
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'multi_json'

class Admin::SpreadSheetsController < Admin::AdminController

  APPLICATION_NAME = 'Fetch from manma\'s spread sheet'
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

  # スプレッドシートにアクセスするための認証を行う
  def authorize
    user_id = current_admin.id
    # 認証用IDとSECRETの生成

    auth_config = {
        web: {
            client_id: ENV['SPREAD_SHEET_CLIENT_ID'],
            client_secret: ENV['SPREAD_SHEET_CLIENT_SECRET']
        }
    }
    # ライブラリを参考にjsonを再読込
    auth_config = MultiJson.load(auth_config.to_json)
    client_id = Google::Auth::ClientId.from_hash(auth_config)
    path = File.join(Rails.root, '.credentials')

    # ディレクトリが存在しなければ作成
    FileUtils.mkdir_p(path) unless FileTest.exist?(path)
    credential_path = File.join(Rails.root, '.credentials', 'sheet.yaml')

    token_store = Google::Auth::Stores::FileTokenStore.new(file: credential_path)
    authorizer = Google::Auth::WebUserAuthorizer.new(client_id, SCOPE, token_store, '/admin/spread_sheets/oauth2callback')
    credentials = authorizer.get_credentials(user_id, request)

    if credentials.nil?
      # redirect_to(...) and return としないとDoubleRenderErrorがスローされるので注意
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request) and return
    end

    # スプレッドシートの情報取得
    response = fetch_spread_sheet(credentials)
    store_users(response, is_debug: true)

    redirect_to admin_family_index_path
  end

  # 認証情報が保存されていなければGoogleアカウントの認証が行われる
  def oauth2callback
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect_to target_url
  end

  private

  # スプレッドシート情報の取得
  # response.value でスプレッドシートから取得したデータを全てを配列で取得することが可能
  # @param [authorize] authorize 認証情報
  # @return [response] response スプレッドシートから取得した情報
  def fetch_spread_sheet(authorize)
    # Initialize the API
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    # 家庭情報スプレッドシートID
    spreadsheet_id = ENV['SPREAD_SHEET_ID']
    sheet_name = 'フォームの回答 1'
    range = "#{sheet_name}!A2:AD"
    response = service.get_spreadsheet_values(spreadsheet_id, range)
    puts 'No data found.' if response.values.empty?

    response
  end

  # レスポンス情報からユーザ情報の保存をする
  # @param [array] response スプレッドシートから取得した情報の配列
  # @param [bool] is_debug trueなら1行のみ処理を行う(動作確認用)
  # TODO: スレッド処理したい pallarelを使う？
  def store_users(response, is_debug: false)
    response.values.map do |r|
      # ユーザ情報のパース
      user_query = {
          spread_sheets_timestamp: r[Settings.sheet.timestamp],
          name: r[Settings.sheet.name],
          kana: r[Settings.sheet.kana],
          gender: 0, # フォームに存在しない情報
          is_family: true,
      }
      user = User.where(user_query).first
      user ||= User.create(user_query)

      # 連絡先情報のパース
      contact_query = {
          user_id: user.id,
          email_pc: r[Settings.sheet.email_pc],
          email_phone: r[Settings.sheet.email_phone],
      }
      contact = Contact.where(contact_query).first
      contact ||= Contact.create(contact_query)

      p contact.errors.messages
      # 位置情報のパース
      location_query = {
          user_id: user.id,
          address: r[Settings.sheet.address]
      }
      location = Location.where(location_query).first
      location ||= Location.create(location_query)
      p location.errors.messages

      # 働き方情報のパース
      job_style = r[Settings.sheet.job_style]
      if job_style == Settings.job_style.str.both
        job_style = Settings.job_style.both
      elsif job_style == Settings.job_style.str.both_single
        job_style = Settings.job_style.both_single
      elsif job_style == Settings.job_style.str.homemaker
        job_style = Settings.job_style.homemaker
      end

      # 男性NG情報のパース
      is_male_ok = r[Settings.sheet.is_male]
      if is_male_ok.blank? or is_male_ok == Settings.is_male.str.all_participant
        is_male_ok = Settings.is_male.ok
      else
        is_male_ok = Settings.is_male.ng
      end

      # SNSへの写真アップロード許可情報のパース
      is_photo = r[Settings.sheet.is_photo]
      if is_photo == Settings.is_photo.str.ng
        is_photo = Settings.is_photo.ng
      elsif is_photo == Settings.is_photo.str.ok
        is_photo = Settings.is_photo.ok
      elsif is_photo == Settings.is_photo.str.caution
        is_photo = Settings.is_photo.caution
      else
        is_photo = nil
      end

      # 家族留学レポート許可情報のパース
      is_report = r[Settings.sheet.is_report]
      if is_report == Settings.is_report.str.ng
        is_report = Settings.is_report.ng
      elsif is_report == Settings.is_report.str.ok
        is_report = Settings.is_report.ok
      elsif is_report == Settings.is_report.str.caution
        is_report = Settings.is_report.caution
      else
        is_report = nil
      end

      # 家族情報のパース
      family_query = {
          user_id: user.id,
          job_style: job_style,
          number_of_children: r[Settings.sheet.number_of_children],
          is_photo_ok: is_photo,
          is_report_ok: is_report,
          is_male_ok: is_male_ok,
          has_time_shortening_experience: r[Settings.sheet.has_time_shortening_experience],
          has_childcare_leave_experience: r[Settings.sheet.has_childcare_leave_experience],
          has_job_change_experience: r[Settings.sheet.has_job_change_experience],
          married_mother_age: r[Settings.sheet.married_mother_age],
          first_childbirth_mother_age: r[Settings.sheet.first_childbirth_mother_age],
          child_birthday: r[Settings.sheet.child_birthday]
      }

      family = ProfileFamily.where(family_query).first
      family ||= ProfileFamily.create(family_query)

      # お母様情報のパース
      mothers_query = {
          profile_family_id: family.id,
          birthday: r[Settings.sheet.mothers_birthday],
          hometown: r[Settings.sheet.mothers_hometown],
          role: 'mother',
          company: r[Settings.sheet.mothers_company],
          career: r[Settings.sheet.mothers_career],
          has_experience_abroad: r[Settings.sheet.mothers_experience_abroad],
          job_domain_id: 1,
          # job_domain_id: row[9], # TODO: 文字列情報のため変換が必要
      }

      # お父様情報のパース
      fathers_query = {
          profile_family_id: family.id,
          birthday: r[Settings.sheet.fathers_birthday],
          hometown: r[Settings.sheet.fathers_hometown],
          role: 'father',
          company: r[Settings.sheet.fathers_company],
          career: r[Settings.sheet.fathers_career],
          has_experience_abroad: r[Settings.sheet.fathers_experience_abroad],
          job_domain_id: 1,
          # job_domain_id: row[10], # TODO: 文字列情報のため変換が必要
      }

      mother = ProfileIndividual.where(mothers_query).first
      mother ||= ProfileIndividual.create(mothers_query)
      p mother.errors.messages
      father = ProfileIndividual.where(fathers_query).first
      father ||= ProfileIndividual.create(fathers_query)
      p father.errors.messages
      # デバッグモード(1行のみ処理)
      break if is_debug
    end
  end

end
