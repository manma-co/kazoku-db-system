require 'rails_helper'

RSpec.describe RequestLog, type: :model do
  describe 'is_rejected_all?' do
    it '全てが未回答状態の場合は、false' do
      request_log = FactoryBot.create(:request_log)
      user = FactoryBot.create(:user)
      FactoryBot.create(:reply_log, request_log: request_log, user: user)
      FactoryBot.create(:reply_log, request_log: request_log, user: user)
      expect(request_log.is_rejected_all?).to eq false
    end

    it '2つのうち1つ拒否されている場合は、false' do
      request_log = FactoryBot.create(:request_log)
      user = FactoryBot.create(:user)
      FactoryBot.create(:reply_log, request_log: request_log, user: user, answer_status: :rejected)
      FactoryBot.create(:reply_log, request_log: request_log, user: user)
      expect(request_log.is_rejected_all?).to eq false
    end

    it '全て拒否されている場合は、true' do
      request_log = FactoryBot.create(:request_log)
      user = FactoryBot.create(:user)
      FactoryBot.create(:reply_log, request_log: request_log, user: user, answer_status: :rejected)
      FactoryBot.create(:reply_log, request_log: request_log, user: user, answer_status: :rejected)
      expect(request_log.is_rejected_all?).to eq true
    end
  end

  describe 'is_already_replied_by_user?' do
    context 'ReplyLogが存在しない場合' do
      it 'falseになること' do
        hash = "hash"
        request_log = FactoryBot.create(:request_log, hashed_key: hash, created_at: Date.current)
        user = FactoryBot.create(:user)
        expect(request_log.is_already_replied_by_user?(user.id)).to eq false
      end
    end
    context 'ReplyLogが存在する場合かつanswer_statusが :no_answerでない場合' do
      it 'trueになること' do
        hash = "hash"
        request_log = FactoryBot.create(:request_log, hashed_key: hash, created_at: Date.current)
        user = FactoryBot.create(:user)
        reply_log = FactoryBot.create(:reply_log, request_log: request_log, user: user, result: true, answer_status: :accepted)
        expect(request_log.is_already_replied_by_user?(user.id)).to eq true
      end
    end
  end

  describe 'self.requesting' do
    context 'ReplyLogが存在しない場合' do
      it '正常系: 経過日数が今日の場合、nilを返すこと' do
        hash = "hash"
        given = FactoryBot.create(:request_log, hashed_key: hash, created_at: Date.current)
        expected = RequestLog.requesting(hash)
        expect(expected).to eq given
      end

      it '正常系: 経過日数が7日の場合、nilを返すこと' do
        hash = "hash"
        given = FactoryBot.create(:request_log, hashed_key: hash, created_at: Date.current - 7.days)
        expected = RequestLog.requesting(hash)
        expect(expected).to eq given
      end

      it '正常系: 経過日数が8日の場合、nilを返すこと' do
        hash = "hash"
        given = FactoryBot.create(:request_log, hashed_key: hash, created_at: Date.current - 8.days)
        expected = RequestLog.requesting(hash)
        expect(expected).to eq nil
      end
    end

    context 'ReplyLogが存在する場合' do
      it '正常系: 少なくとも1つがマッチング成立していれば(resultがtrue)nilを返すこと' do
        hash = "hash"
        request_log = FactoryBot.create(:request_log, hashed_key: hash, created_at: Date.current)
        user = FactoryBot.create(:user)
        reply_log = FactoryBot.create(:reply_log, request_log: request_log, user: user, result: true)
        expected = RequestLog.requesting(hash)
        expect(expected).to eq nil
      end

      it '正常系: マッチングが成立していなければ(resultがfalse)取得できること' do
        hash = "hash"
        request_log = FactoryBot.create(:request_log, hashed_key: hash, created_at: Date.current)
        user = FactoryBot.create(:user)
        reply_log = FactoryBot.create(:reply_log, request_log: request_log, user: user, result: false)
        expected = RequestLog.requesting(hash)
        expect(expected).to eq request_log
      end
    end
  end

  describe 'self.get_all_seven_days_before_for_remind' do
    it '正常系: EventDateが存在する場合、RequestLogが取得できないこと' do
      given = FactoryBot.create(:request_log, created_at: 7.days.ago)
      user = FactoryBot.create(:user)
      given.event_date = FactoryBot.build(:event_date, user: user)
      given.email_queue << FactoryBot.build(:email_queue, email_type: Settings.email_type.matching_start)
      given.save!
      expected = RequestLog.get_all_seven_days_before_for_remind
      expect(expected).to eq []
    end

    it '正常系: EmailQueueのemail_typeがreadjustmentでない(少なくとも1家庭が返信しなかった）場合かつ、6日前のRequestLogは取得できないこと' do
      given = FactoryBot.create(:request_log, created_at: 6.days.ago)
      given.email_queue << FactoryBot.build(:email_queue, email_type: Settings.email_type.matching_start)
      given.save!
      expected = RequestLog.get_all_seven_days_before_for_remind
      expect(expected).to eq []
    end

    it '正常系: EmailQueueのemail_typeがreadjustmentでない(少なくとも1家庭が返信しなかった）場合かつ、8日前のRequestLogは取得できないこと' do
      given = FactoryBot.create(:request_log, created_at: 6.days.ago)
      given.email_queue << FactoryBot.build(:email_queue, email_type: Settings.email_type.matching_start)
      given.save!
      expected = RequestLog.get_all_seven_days_before_for_remind
      expect(expected).to eq []
    end

    it '正常系: EmailQueueのemail_typeがreadjustmentである(すべての家庭が返信した）場合かつ、7日前のRequestLogが取得できないこと' do
      given = FactoryBot.create(:request_log, created_at: 7.days.ago)
      given.email_queue << FactoryBot.build(:email_queue, email_type: Settings.email_type.readjustment)
      given.save!
      expected = RequestLog.get_all_seven_days_before_for_remind
      expect(expected).to eq []
    end

    it '正常系: EmailQueueのemail_typeがreadjustmentでない(少なくとも1家庭が返信しなかった）場合かつ、7日前のRequestLogが取得できること' do
      given = FactoryBot.create(:request_log, created_at: 7.days.ago)
      given.email_queue << FactoryBot.build(:email_queue, email_type: Settings.email_type.matching_start)
      given.save!
      expected = RequestLog.get_all_seven_days_before_for_remind
      expect(expected).to eq [given]
    end
  end
end
