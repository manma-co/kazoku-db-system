require 'googleauth'
require 'google_drive'
require 'json'

module Google
  class AuthorizeWithWriteByServiceAccount
    SHEET_ID = ENV['SPREAD_SHEETS_FOR_WRITE_ID']

    def self.do(row)
      credentials = Google::SpreadSheetAuthorizeService.credentials
      session = GoogleDrive::Session.new(credentials)
      sheet = session.spreadsheet_by_key(SHEET_ID).worksheets[0]

      # 配列を展開して、Spreadsheetのデータ未挿入行かつ先頭列からデータを挿入
      # データが挿入されている行の次の行に挿入したいため +1 をする
      insert_row_index = sheet.num_rows + 1
      row.each_with_index do |r, index|
        sheet[insert_row_index, index + 1] = r
      end
      sheet.save
    end
  end
end
