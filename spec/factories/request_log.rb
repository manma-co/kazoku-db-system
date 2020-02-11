FactoryBot.define do
  factory :request_log do
    hashed_key { "hashed" }
    name { "name" }
    belongs { "所属" }
    station { "最寄り駅" }
    emergency { "緊急連絡先" }
    motivation { "応募動機" }
    email { "test@gmail.com" }

    trait :has_email_queue do
      transient { has_contact { true } }
    end
  end
end
