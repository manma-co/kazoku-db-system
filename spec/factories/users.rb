FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:kana) { |n| "TEST_NAME_KANA#{n}" }
    gender 1
  end
end
