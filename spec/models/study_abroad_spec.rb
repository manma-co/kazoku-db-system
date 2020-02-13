require 'rails_helper'

RSpec.describe StudyAbroad, type: :model do
  describe 'is_rejected_all?' do
    it '全てが未回答状態の場合は、false' do
      study_abroad = FactoryBot.create(:study_abroad)
      user = FactoryBot.create(:user)
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user)
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user)
      expect(study_abroad.is_rejected_all?).to eq false
    end

    it '2つのうち1つ拒否されている場合は、false' do
      study_abroad = FactoryBot.create(:study_abroad)
      user = FactoryBot.create(:user)
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user, answer_status: :rejected)
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user)
      expect(study_abroad.is_rejected_all?).to eq false
    end

    it '全て拒否されている場合は、true' do
      study_abroad = FactoryBot.create(:study_abroad)
      user = FactoryBot.create(:user)
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user, answer_status: :rejected)
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user, answer_status: :rejected)
      expect(study_abroad.is_rejected_all?).to eq true
    end
  end

  describe 'is_already_replied_by_user?' do
    context 'ReplyLogが存在しない場合' do
      it 'falseになること' do
        hash = 'hash'
        study_abroad = FactoryBot.create(:study_abroad, hashed_key: hash, created_at: Date.current)
        user = FactoryBot.create(:user)
        expect(study_abroad.is_already_replied_by_user?(user.id)).to eq false
      end
    end

    context 'ReplyLogが存在する場合かつanswer_statusが :no_answerでない場合' do
      it 'trueになること' do
        hash = 'hash'
        study_abroad = FactoryBot.create(:study_abroad, hashed_key: hash, created_at: Date.current)
        user = FactoryBot.create(:user)
        FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user, result: true, answer_status: :accepted)
        expect(study_abroad.is_already_replied_by_user?(user.id)).to eq true
      end
    end
  end

  describe 'self.requesting' do
    context 'ReplyLogが存在しない場合' do
      it '正常系: 経過日数が今日の場合、nilを返すこと' do
        hash = 'hash'
        given = FactoryBot.create(:study_abroad, hashed_key: hash, created_at: Date.current)
        expected = described_class.requesting(hash)
        expect(expected).to eq given
      end

      it '正常系: 経過日数が7日の場合、nilを返すこと' do
        hash = 'hash'
        given = FactoryBot.create(:study_abroad, hashed_key: hash, created_at: Date.current - 7.days)
        expected = described_class.requesting(hash)
        expect(expected).to eq given
      end

      it '正常系: 経過日数が8日の場合、nilを返すこと' do
        hash = 'hash'
        FactoryBot.create(:study_abroad, hashed_key: hash, created_at: Date.current - 8.days)
        expected = described_class.requesting(hash)
        expect(expected).to eq nil
      end
    end

    context 'ReplyLogが存在する場合' do
      it '正常系: 少なくとも1つがマッチング成立していれば(resultがtrue)nilを返すこと' do
        hash = 'hash'
        study_abroad = FactoryBot.create(:study_abroad, hashed_key: hash, created_at: Date.current)
        user = FactoryBot.create(:user)
        FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user, result: true)
        expected = described_class.requesting(hash)
        expect(expected).to eq nil
      end

      it '正常系: マッチングが成立していなければ(resultがfalse)取得できること' do
        hash = 'hash'
        study_abroad = FactoryBot.create(:study_abroad, hashed_key: hash, created_at: Date.current)
        user = FactoryBot.create(:user)
        FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user, result: false)
        expected = described_class.requesting(hash)
        expect(expected).to eq study_abroad
      end
    end
  end

  describe 'self.all_three_days_before_for_remind' do
    it '正常系EventDateが存在する場合、StudyAbroadが取得できないこと' do
      given = FactoryBot.create(:study_abroad, created_at: 3.days.ago)
      user = FactoryBot.create(:user)
      FactoryBot.create(:event_date, user: user, study_abroad: given)
      expected = described_class.all_three_days_before_for_remind
      expect(expected).to eq []
    end

    it '正常系: ReplyLogのanswer_statusが全て未回答で3日たった場合、StudyAbroadが取得できること' do
      given = FactoryBot.create(:study_abroad, created_at: 3.days.ago)
      user = FactoryBot.create(:user)
      FactoryBot.create(:study_abroad_request, user: user, study_abroad: given)
      expected = described_class.all_three_days_before_for_remind
      expect(expected).to eq [given]
      expect(expected[0].study_abroad_request).to eq given.study_abroad_request
    end

    it '正常系: ReplyLogのanswer_statusの少なくとも1つが :rejectedの場合、StudyAbroadは取得できること' do
      given = FactoryBot.create(:study_abroad, created_at: 3.days.ago)
      user = FactoryBot.create(:user)
      FactoryBot.create(:study_abroad_request, user: user, study_abroad: given, answer_status: :rejected)
      FactoryBot.create(:study_abroad_request, user: user, study_abroad: given, answer_status: :no_answer)
      expected = described_class.all_three_days_before_for_remind
      expect(expected).to eq [given]
    end
  end

  describe 'self.all_seven_days_before_for_remind' do
    it '正常系: EventDateが存在する場合、StudyAbroadが取得できないこと' do
      given = FactoryBot.create(:study_abroad, created_at: 7.days.ago)
      user = FactoryBot.create(:user)
      FactoryBot.create(:event_date, user: user, study_abroad: given)
      expected = described_class.all_seven_days_before_for_remind
      expect(expected).to eq []
    end

    it '正常系: EventDateが存在しない場合、7日前のStudyAbroadが取得できること' do
      given = FactoryBot.create(:study_abroad, created_at: 7.days.ago)
      FactoryBot.create(:user)
      expected = described_class.all_seven_days_before_for_remind
      expect(expected).to eq [given]
    end

    it '正常系: 6日前のStudyAbroadは取得できないこと' do
      FactoryBot.create(:study_abroad, created_at: 6.days.ago)
      expected = described_class.all_seven_days_before_for_remind
      expect(expected).to eq []
    end

    it '正常系: 8日前のStudyAbroadは取得できないこと' do
      FactoryBot.create(:study_abroad, created_at: 8.days.ago)
      expected = described_class.all_seven_days_before_for_remind
      expect(expected).to eq []
    end
  end
end
