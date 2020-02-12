FactoryBot.define do
  factory :user do
    transient do
      has_contact { false }
      has_profile_family { false }
      has_requests { false }
    end

    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:kana) { |n| "TEST_NAME_KANA#{n}" }
    gender { 1 }

    trait :with_contact do
      transient { has_contact { true } }
    end

    trait :with_profile_family do
      transient { has_profile_family { true } }
    end

    trait :with_requests do
      transient { has_requests { true } }
    end

    factory :perfect_user, traits: %i[with_contact with_profile_family]

    after :build do |user, evaluator|
      if evaluator.has_contact
        user.contact = FactoryBot.build(:contact, user: user)
      end
      if evaluator.has_profile_family
        user.profile_family = FactoryBot.build(:profile_family, user: user)
      end
    end
  end
end
