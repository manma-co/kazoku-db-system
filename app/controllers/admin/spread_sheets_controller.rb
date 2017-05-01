# スプレッドシートからユーザ情報を取得するためのコントローラ
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'

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
    client_id = Google::Auth::ClientId.from_hash(auth_config)
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
    store_users(response)

    redirect_to admin_family_index_path
  end

  def oauth2callback
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect_to target_url
  end

  private

  # スプレッドシート情報の取得
  def fetch_spread_sheet(authorize)
    # Initialize the API
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    # 家庭情報スプレッドシートID
    # spreadsheet_id = '13z-3YJLbz7YPLL6a2nM-ub1eT-JGIb0tZZ4ggq0jw3o'
    spreadsheet_id = ENV['SPREAD_SHEET_ID']
    sheet_name = 'フォームの回答 1'
    range = "#{sheet_name}!A2:AD"
    response = service.get_spreadsheet_values(spreadsheet_id, range)
    puts 'No data found.' if response.values.empty?

    response.values.each do |row|
      puts "#{row[1]}"
    end
    response
  end

  # レスポンス情報からユーザ情報の保存をする
  def store_users(response)
    response.values.map do |row|
          # ユーザ情報のパース
          user_query = {
              spread_sheets_timestamp: row[0],
              name: row[1],
              kana: row[2],
              gender: 0, # フォームに存在しない情報
              is_family: true,
          }
          user = User.where(user_query).first
          user ||= User.create(user_query)

          # 連絡先情報のパース
          contact_query = {
              user_id: user.id,
              email_pc: row[3],
              email_phone: row[4],
          }
          contact = Contact.where(contact_query).first
          contact ||= Contact.create(contact_query)

          p contact.errors.messages
          # 位置情報のパース
          location_query = {
              user_id: user.id,
              address: row[5]
          }
          location = Location.where(location_query).first
          location ||= Location.create(location_query)
          p location.errors.messages

          # 家族情報のパース
          job_style = row[8]
          # TODO: 共働き※シングルマザーの情報の扱いについては別途相談
          if job_style == '共働き' or job_style == '共働き ※シングルマザー（ファザー）含む'
            job_style = 0
          elsif job_style == 'どちらかが専業主婦（夫）'
            job_style = 1
          end

          is_male_ok = row[29]
          if is_male_ok.blank? or is_male_ok == '全参加者'
            is_male_ok = 1
          else
            is_male_ok = 0
          end

          family_query = {
              user_id: user.id,
              job_style: job_style, # TODO: 文字列情報のため変換が必要
              number_of_children: row[11],
              # is_sns_ok: row[12], # TODO: 文字列情報のため変換が必要
              # is_photo_ok: row[13], # TODO: 文字列情報のため変換が必要
              is_male_ok: is_male_ok, # TODO: 文字列情報のため変換が必要
          }

          family = ProfileFamily.where(family_query).first
          family ||= ProfileFamily.create(family_query)

          # お母様情報のパース
          mothers_query = {
              profile_family_id: family.id,
              birthday: row[6],
              job_domain_id: 0,
              # job_domain_id: row[9], # TODO: 文字列情報のため変換が必要
          }

          # お父様情報のパース
          fathers_query = {
              profile_family_id: family.id,
              birthday: row[7],
              job_domain_id: 0,
              # job_domain_id: row[10], # TODO: 文字列情報のため変換が必要
          }

          mother = ProfileIndividual.where(mothers_query)
          mother ||= ProfileIndividual.create(mothers_query)
          father = ProfileIndividual.where(fathers_query)
          father ||= ProfileIndividual.create(fathers_query)

    end
  end

end