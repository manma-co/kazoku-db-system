require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'multi_json'

module Google
  class SpreadSheetWriteService
    APPLICATION_NAME = 'Write from manma\'s spread sheet'.freeze

    # スプレッドシートに書き込みをする
    # @param [authorize] authorize 認証情報
    # @param [row] 書き込み情報 2重配列で表現すること
    # 例: [["hoge", "fuga"], ["piyo", "mag"]] 空行にhoge、隣の列にfugaが挿入される。次の空行にpiyo、隣の列にmagが挿入される
    def self.do(authorize, row)
      # Initialize the API
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize

      case ENV['RAILS_ENV']
      when 'development', 'test'
        # テスト用SpreadSheet
        spreadsheet_id = '1Mj7LlJjNwnUGpXisGEsuMJPKWZKpBSSada4KQsZP9bw'
      when 'production'
        # 本番用SpreadSheet
        spreadsheet_id = ENV['SPREAD_SHEETS_FOR_WRITE_ID']
      end
      sheet_name = 'フォームの回答'
      range = sheet_name.to_s
      value = Google::Apis::SheetsV4::ValueRange.new

      # 電話番号の先頭の0が消えてしまう問題は、spread sheetの書式設定の変更で解決する
      # 参考: http://lionspec.seesaa.net/article/395984881.html
      value.values = [row]

      # 参考: ValueInputOption(https://developers.google.com/sheets/api/reference/rest/v4/ValueInputOption)
      value_input_options = 'USER_ENTERED'
      service.append_spreadsheet_value(spreadsheet_id, range, value, value_input_option: value_input_options)
    end
  end
end
