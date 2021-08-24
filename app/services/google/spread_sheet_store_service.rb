require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'multi_json'

module Google
  class SpreadSheetStoreService
    # レスポンス情報からユーザ情報の保存をする
    # @param [array] response スプレッドシートから取得した情報の配列
    # @param [bool] is_debug trueなら1行のみ処理を行う(動作確認用)
    # TODO: スレッド処理したい pallarelを使う？
    def self.store_family_to_db(response, is_debug: false)
      response.values.map do |r|
        # ユーザ情報のパース
        user_query = {
          name: r[Settings.sheet.name],
          kana: r[Settings.sheet.kana],
          gender: 0, # フォームに存在しない情報
          is_family: true
        }
        user = User.find_or_initialize_by(spread_sheets_timestamp: r[Settings.sheet.timestamp])
        user.update(user_query)

        # 連絡先情報のパース
        contact_query = {
          email_pc: r[Settings.sheet.email_pc],
          email_phone: r[Settings.sheet.email_pc],
          phone_number: r[Settings.sheet.phone_number]
        }
        contact = Contact.find_or_initialize_by(user_id: user.id)
        contact.update(contact_query)

        # 位置情報のパース
        location_query = {
          address: r[Settings.sheet.address],
          latitude: r[Settings.sheet.latitude],
          longitude: r[Settings.sheet.longitude]
        }
        location = Location.find_or_initialize_by(user_id: user.id)
        location.update(location_query)

        # デバッグモード(1行のみ処理)
        break if is_debug
      end
    end

    # レスポンス情報からユーザ情報の保存をする
    # @param [array] response スプレッドシートから取得した情報の配列
    # @param [bool] is_debug trueなら1行のみ処理を行う(動作確認用)
    def self.store_participant_to_db(response, is_debug: false)
      response.values.map do |r|
        query = {
          # ユーザ情報のパース
          name: r[Settings.participant.name],
          kana: r[Settings.participant.kana],
          belong: r[Settings.participant.belong],
          email: r[Settings.participant.email]
        }
        # 存在チェック
        participant = Participant.find_or_initialize_by(query)
        participant.update(query)

        # デバッグモード(1行のみ取得)
        break if is_debug
      end
    end
  end
end
