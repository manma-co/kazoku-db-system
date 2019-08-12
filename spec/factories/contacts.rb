FactoryBot.define do
  factory :contact do
    transient do
      domain {"example.com"}
    end
    sequence(:email_pc) { |n| "test#{n}@#{domain}" }
    sequence(:email_phone) { |n| "test#{n}_mobile@#{domain}" }
    sequence(:phone_number) { |n| "0901234567#{n}"}
  end
end
