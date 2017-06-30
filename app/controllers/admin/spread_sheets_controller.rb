# スプレッドシートからユーザ情報を取得するためのコントローラ
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'multi_json'

class Admin::SpreadSheetsController < Admin::AdminController

  # スプレッドシートにアクセスするための認証を行う
  def authorize
    user_id = current_admin.id

    credentials = Google::SpreadSheetAuthorizeService.do(request, user_id)

    if credentials.nil?
      # redirect_to(...) and return としないとDoubleRenderErrorがスローされるので注意
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request) and return
    end

    # スプレッドシートの情報取得
    response = Google::SpreadSheetFetchService.do(credentials)
    Google::SpreadSheetStoreService.do(response, is_debug: false)

    redirect_to admin_family_index_path
  end

  # 認証情報が保存されていなければGoogleアカウントの認証が行われる
  def oauth2callback
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect_to target_url
  end

end
