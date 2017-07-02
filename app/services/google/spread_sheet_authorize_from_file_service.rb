require 'googleauth'
require 'googleauth/stores/file_token_store'

# ファイルからGoogleの認証を通す
module Google
  class SpreadSheetAuthorizeFromFileService

    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    # 認証用IDとSECRETの生成
    AUTH_CONFIG = {
      web: {
        client_id: ENV['SPREAD_SHEET_CLIENT_ID'],
        client_secret: ENV['SPREAD_SHEET_CLIENT_SECRET']
      }
    }

    def self.do(user_id)
      # ライブラリを参考にjsonを再読込
      auth_config = MultiJson.load(AUTH_CONFIG.to_json)
      client_id = Google::Auth::ClientId.from_hash(auth_config)
      path = File.join(Rails.root, '.credentials')

      # ディレクトリが存在しなければ作成
      FileUtils.mkdir_p(path) unless FileTest.exist?(path)
      credential_path = File.join(Rails.root, '.credentials', 'sheet.yaml')

      token_store = Google::Auth::Stores::FileTokenStore.new(file: credential_path)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      credentials = authorizer.get_credentials(user_id)
      [authorizer, credentials]
    end

  end
end
