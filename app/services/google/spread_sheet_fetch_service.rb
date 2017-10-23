require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'multi_json'

module Google
  class SpreadSheetFetchService

    APPLICATION_NAME = 'Fetch from manma\'s spread sheet'

    # スプレッドシート情報の取得(家庭向け)
    # response.value でスプレッドシートから取得したデータを全てを配列で取得することが可能
    # @param [authorize] authorize 認証情報
    # @return [response] response スプレッドシートから取得した情報
    def self.fetch_family(authorize)
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

    # スプレッドシート情報の取得(参加者向け)
    # response.value でスプレッドシートから取得したデータを全てを配列で取得することが可能
    # @param [authorize] authorize 認証情報
    # @return [response] response スプレッドシートから取得した情報
    def self.fetch_participant(authorize)
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize

      # 参加者情報スプレッドシートID
      spreadsheet_id = ENV['PARTICIPANT_SPREAD_SHEET_ID']
      sheet_name = 'manmaシステム利用'

      range = "#{sheet_name}!A2:AD"
      response = service.get_spreadsheet_values(spreadsheet_id, range)
      puts 'No data found.' if response.values.empty?

      response
    end
  end
end