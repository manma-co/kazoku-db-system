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
    def self.store_family(response, is_debug: false)
      response.values.map do |r|
        # ユーザ情報のパース
        user_query = {
          spread_sheets_timestamp: r[Settings.sheet.timestamp],
          name: r[Settings.sheet.name],
          kana: r[Settings.sheet.kana],
          gender: 0, # フォームに存在しない情報
          is_family: true,
        }
        user = User.find_or_initialize_by(user_query)
        user.update_attributes(user_query)

        # 連絡先情報のパース
        contact_query = {
          user_id: user.id,
          email_pc: r[Settings.sheet.email_pc],
          email_phone: r[Settings.sheet.email_phone],
          phone_number: r[Settings.sheet.phone_number]
        }
        contact = Contact.find_or_initialize_by(contact_query)
        contact.update_attributes(contact_query)

        # 位置情報のパース
        location_query = {
          user_id: user.id,
          address: r[Settings.sheet.address],
          latitude: r[Settings.sheet.latitude],
          longitude: r[Settings.sheet.longitude]
        }
        location = Location.find_or_initialize_by(location_query)
        location.update_attributes(location_query)

        # 働き方情報のパース
        job_style = r[Settings.sheet.job_style]
        if job_style == Settings.job_style.str.both
          job_style = Settings.job_style.both
        elsif job_style == Settings.job_style.str.both_single
          job_style = Settings.job_style.both_single
        elsif job_style == Settings.job_style.str.homemaker
          job_style = Settings.job_style.homemaker
        end

        # 男性NG情報のパース
        is_male_ok = r[Settings.sheet.is_male]
        if is_male_ok.blank? or is_male_ok == Settings.is_male.str.all_participant
          is_male_ok = Settings.is_male.ok
        else
          is_male_ok = Settings.is_male.ng
        end

        # SNSへの写真アップロード許可情報のパース
        is_photo = r[Settings.sheet.is_photo]
        if is_photo == Settings.is_photo.str.ng
          is_photo = Settings.is_photo.ng
        elsif is_photo == Settings.is_photo.str.ok
          is_photo = Settings.is_photo.ok
        elsif is_photo == Settings.is_photo.str.caution
          is_photo = Settings.is_photo.caution
        else
          is_photo = nil
        end

        # 家族留学レポート許可情報のパース
        is_report = r[Settings.sheet.is_report]
        if is_report == Settings.is_report.str.ng
          is_report = Settings.is_report.ng
        elsif is_report == Settings.is_report.str.ok
          is_report = Settings.is_report.ok
        elsif is_report == Settings.is_report.str.caution
          is_report = Settings.is_report.caution
        else
          is_report = nil
        end

        # 家族情報のパース
        family_query = {
          user_id: user.id,
          job_style: job_style,
          number_of_children: r[Settings.sheet.number_of_children],
          is_photo_ok: is_photo,
          is_report_ok: is_report,
          is_male_ok: is_male_ok,
          has_time_shortening_experience: r[Settings.sheet.has_time_shortening_experience],
          has_childcare_leave_experience: r[Settings.sheet.has_childcare_leave_experience],
          has_job_change_experience: r[Settings.sheet.has_job_change_experience],
          married_mother_age: r[Settings.sheet.married_mother_age],
          married_father_age: r[Settings.sheet.married_father_age],
          first_childbirth_mother_age: r[Settings.sheet.first_childbirth_mother_age],
          child_birthday: r[Settings.sheet.child_birthday]
        }

        family = ProfileFamily.find_or_initialize_by(family_query)
        family.update_attributes(family_query)

        # お母様情報のパース
        mothers_query = {
          profile_family_id: family.id,
          birthday: r[Settings.sheet.mothers_birthday],
          hometown: r[Settings.sheet.mothers_hometown],
          role: 'mother',
          company: r[Settings.sheet.mothers_company],
          career: r[Settings.sheet.mothers_career],
          has_experience_abroad: r[Settings.sheet.mothers_experience_abroad],
          job_domain_id: 1,
          # job_domain_id: row[9], # TODO: 文字列情報のため変換が必要
        }

        # お父様情報のパース
        fathers_query = {
          profile_family_id: family.id,
          birthday: r[Settings.sheet.fathers_birthday],
          hometown: r[Settings.sheet.fathers_hometown],
          role: 'father',
          company: r[Settings.sheet.fathers_company],
          career: r[Settings.sheet.fathers_career],
          has_experience_abroad: r[Settings.sheet.fathers_experience_abroad],
          job_domain_id: 1,
          # job_domain_id: row[10], # TODO: 文字列情報のため変換が必要
        }

        mothers_profile = ProfileIndividual.find_or_initialize_by(mothers_query)
        mothers_profile.update_attributes(mothers_query)

        fathers_profile = ProfileIndividual.find_or_initialize_by(fathers_query)
        fathers_profile.update_attributes(fathers_query)

        # デバッグモード(1行のみ処理)
        break if is_debug
      end
    end

    # レスポンス情報からユーザ情報の保存をする
    # @param [array] response スプレッドシートから取得した情報の配列
    # @param [bool] is_debug trueなら1行のみ処理を行う(動作確認用)
    # TODO: スレッド処理したい pallarelを使う？
    def self.store_participant(response, is_debug: false)
      response.values.map do |r|

        query = {
          # ユーザ情報のパース
          name: r[Settings.participant.name],
          kana: r[Settings.participant.kana],
          belong: r[Settings.participant.belong],
          email: r[Settings.participant.email],
        }

        # 存在チェック
        p = Participant.where(email: email).first
        if p.nil?
          Participant.create(name: name, kana: kana, belong: belong, email: email)
        end

        # デバッグモード(1行のみ取得)
        break if is_debug
      end
    end
  end
end