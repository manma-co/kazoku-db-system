require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'multi_json'

module Google
  class SpreadSheetWriteService

    APPLICATION_NAME = 'Write from manma\'s spread sheet'

    # スプレッドシートに書き込み
    # @param [authorize] authorize 認証情報
    # @param [family_abroad_request] 家族留学情報
    def self.do(authorize, family_abroad_request)
      # Initialize the API
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize

      spreadsheet_id = '1Mj7LlJjNwnUGpXisGEsuMJPKWZKpBSSada4KQsZP9bw'
      sheet_name = '家族留学'
      range = "#{sheet_name}"
      value = Google::Apis::SheetsV4::ValueRange.new
      value.values = [[ DateTime.current.strftime('%Y/%m/%d %H:%M:%S'), "お名前情報"]]

      # 参考: ValueInputOption(https://developers.google.com/sheets/api/reference/rest/v4/ValueInputOption)
      value_input_options = 'USER_ENTERED'
      service.append_spreadsheet_value(spreadsheet_id, range, value, value_input_option: value_input_options)

  end
end