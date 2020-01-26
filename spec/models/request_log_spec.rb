require 'rails_helper'

RSpec.describe RequestLog, type: :model do
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
