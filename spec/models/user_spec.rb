require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'job_style_str' do
    subject(:job_style_str) { user.job_style_str }

    let(:user) { FactoryBot.create(:user, :with_profile_family) }

    context 'when user.profile_family.job_style set value' do
      it 'is 共働き' do
        user.profile_family.job_style = Settings.job_style.both
        expect(job_style_str).to eq '共働き'
      end
    end

    context 'when user.profile_family.job_style is nil' do
      it 'returns empty string' do
        user = FactoryBot.create(:user, :with_profile_family)
        user.profile_family.job_style = nil
        expect(job_style_str).to eq ''
      end
    end
  end
end
