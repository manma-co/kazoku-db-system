# スプレッドシートからユーザ情報を取得するためのコントローラ
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'multi_json'

class Admin::SpreadSheetsController < Admin::AdminController

  # スプレッドシートへのアクセス認証後、家庭情報を取得する
  def fetch_family
    user_id = ENV['SPREAD_SHEET_AUTH_UNIQUE_ID']
    authorizer, credentials = Google::SpreadSheetAuthorizeService.do(request, user_id)
    if credentials.nil?
      # redirect_to(...) and return としないとDoubleRenderErrorがスローされるので注意
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request) and return
    end

    # スプレッドシートの情報取得(家庭向け)
    response = Google::SpreadSheetFetchService.fetch_family(credentials)

    # スプレッドシート情報の保存(家庭向け)
    Google::SpreadSheetStoreService.store_family(response, is_debug: false)

    redirect_to admin_family_index_path
  end

  # スプレッドシートにアクセス認証後、参加者情報を取得する
  def fetch_student
    user_id = ENV['SPREAD_SHEET_AUTH_UNIQUE_ID']
    authorizer, credentials = Google::SpreadSheetAuthorizeService.do(request, user_id)
    if credentials.nil?
      # redirect_to(...) and return としないとDoubleRenderErrorがスローされるので注意
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request) and return
    end

    # スプレッドシートの情報取得(参加者向け)
    response = Google::SpreadSheetFetchService.fetch_student(credentials)

    redirect_to admin_family_index_path
  end

  # 認証情報が保存されていなければGoogleアカウントの認証が行われる
  def oauth2callback
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect_to target_url
  end

end
