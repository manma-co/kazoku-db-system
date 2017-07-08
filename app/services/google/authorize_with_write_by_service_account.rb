require 'googleauth'
require 'google_drive'
require 'json'

# Oauth認証を通してSpreadsheetに書き込みを行う
module Google
  class AuthorizeWithWriteByServiceAccount
    SHEET_ID = ENV['SPREAD_SHEETS_FOR_WRITE_ID']
    JSON_FILE_PATH = ENV['AUTH_JSON_PATH']

    def self.do(array, is_debug = false)
      path = File.join(Rails.root, '.credentials', 'manma-mothership.json')

      session = GoogleDrive::Session.from_service_account_key(path)
      ws = session.spreadsheet_by_key(SHEET_ID).worksheets[0]

      # 配列を展開して、Spreadsheetのデータ未挿入行かつ先頭列からデータを挿入
      # データが挿入されている行の次の行に挿入したいため +1 をする
      insert_row_index = ws.num_rows + 1
      array.each_with_index do |a, index|
        ws[insert_row_index, index + 1] = a
      end
      ws.save

      print(ws) if is_debug
    end

    private

    def print(ws)
      # 整形処理 & 表示
      table = (1..ws.num_rows).map do |row|
        (1..ws.num_cols).map do |col|
          ws[row, col]
        end
      end

      table.each do |row|
        puts row.join("\t")
      end
    end
  end
end
