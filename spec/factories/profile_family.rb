FactoryBot.define do
  factory :profile_family do
    # profile_family - 作成されたインスタンス自身
    # evaluator - ignore(trasient)内の属性を含むファクトリの全ての属性を保持
    after(:build) do |profile_family, _evaluator|
      profile_family.profile_individuals << FactoryBot.build(:mother)
      profile_family.profile_individuals << FactoryBot.build(:father)
    end
  end
end
