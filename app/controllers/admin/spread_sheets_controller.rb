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

    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    credentials = authorizer.get_credentials(user_id)

    if credentials.nil?
      authorizer = Google::Auth::WebUserAuthorizer.new(client_id, SCOPE, token_store, '/admin/spread_sheets/oauth2callback')
      credentials = authorizer.get_credentials(user_id, request)
    end

    if credentials.nil?
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request)
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
    spreadsheet_id = '13z-3YJLbz7YPLL6a2nM-ub1eT-JGIb0tZZ4ggq0jw3o'
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
      # TODO: 後ほど
      query = {}
      puts "#{row[1]}"
    end

  end

end