require 'rails_helper'

# rubocop:disable all
RSpec.describe MailerBody do
  describe 'self.notify_to_candidate' do
    let(:study_abroad) { FactoryBot.create(:study_abroad, name: "参加者太郎") }
    let(:user) { FactoryBot.create(:perfect_user, name: "受け入れ太郎") }
    context 'when input all information' do
      it 'returns expected body' do
        user.profile_family.job_style = Settings.job_style.both
        user.contact.email_pc = "test1@example.com"
        event_date = FactoryBot.create(
          :event_date,
          study_abroad: study_abroad,
          user: user,
          start_time: Time.utc(2010, 6, 29, 10, 15, 0),
          end_time: Time.utc(2010, 6, 29, 12, 15, 0)
        )
        body = described_class.notify_to_candidate(event_date, study_abroad, user)
        expected_body = <<~EOS

          参加者太郎 様

          この度、家族留学のマッチングが成立いたしましたのでご連絡させていただきます。</p>

          キャンセルは原則として不可となります。
          止むを得ない事情でキャンセルされる方は
          至急 info@manma.co に理由を明記の上、ご連絡ください。

          下記の内容で、家族留学を実施させていただきます。

          実施予定日の10日前にご家庭とお繋ぎさせていただきます。
          スケジュールを確保のうえ、いましばらくお待ち下さい。

          ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

          受け入れ家庭のお名前: 受け入れ太郎
          受け入れ家庭の家族構成: 共働き
          受け入れ家庭の緊急連絡先: test1@example.com
          実施日時: 00時00分
          実施開始時間: 10時15分
          実施終了時間: 12時15分
          集合場所: 東京駅
          備考: information text
          ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

          また、ご質問等ございましたら
          info@manma.co までご連絡ください。

          引き続き、どうぞよろしくお願いいたします。

          manma

        EOS

        expect(body).to eq expected_body
      end
    end

    context 'when job_style is nil' do
      it 'returns expected body' do
        user.profile_family.job_style = nil
        user.contact.email_pc = "test1@example.com"
        event_date = FactoryBot.create(
          :event_date,
          study_abroad: study_abroad,
          user: user,
          start_time: Time.utc(2010, 6, 29, 10, 15, 0),
          end_time: Time.utc(2010, 6, 29, 12, 15, 0)
        )
        body = described_class.notify_to_candidate(event_date, study_abroad, user)
        expected_body = <<~EOS

          参加者太郎 様

          この度、家族留学のマッチングが成立いたしましたのでご連絡させていただきます。</p>

          キャンセルは原則として不可となります。
          止むを得ない事情でキャンセルされる方は
          至急 info@manma.co に理由を明記の上、ご連絡ください。

          下記の内容で、家族留学を実施させていただきます。

          実施予定日の10日前にご家庭とお繋ぎさせていただきます。
          スケジュールを確保のうえ、いましばらくお待ち下さい。

          ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

          受け入れ家庭のお名前: 受け入れ太郎
          受け入れ家庭の緊急連絡先: test1@example.com
          実施日時: 00時00分
          実施開始時間: 10時15分
          実施終了時間: 12時15分
          集合場所: 東京駅
          備考: information text
          ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

          また、ご質問等ございましたら
          info@manma.co までご連絡ください。

          引き続き、どうぞよろしくお願いいたします。

          manma

        EOS

        expect(body).to eq expected_body
      end
    end
  end
end
# rubocop:enable all
