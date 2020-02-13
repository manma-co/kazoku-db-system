require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'multi_json'

module Google
  class SpreadSheetAuthorizeService
    # @return credentials
    def self.credentials
      # MEMO: 下記環境変数の設定が必要
      # "GOOGLE_CLIENT_ID",
      # "GOOGLE_CLIENT_EMAIL",
      # "GOOGLE_ACCOUNT_TYPE",
      # "GOOGLE_PRIVATE_KEY"
      Google::Auth::ServiceAccountCredentials.make_creds(scope: [
                                                           'https://www.googleapis.com/auth/drive',
                                                           'https://www.googleapis.com/auth/spreadsheets'
                                                         ])
    end
  end
end
