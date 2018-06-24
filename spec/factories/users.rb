FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:kana) { |n| "TEST_NAME_KANA#{n}" }
    gender 1

    after :build do |user|
      user.contact = FactoryBot.build(:contact, user: user)
      user.profile_family = FactoryBot.build(:profile_family, user: user)
    end
  end
end
