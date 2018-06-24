FactoryBot.define do
  factory :mother, class: ProfileIndividual do
    role 'mother'
    association :job_domain
  end

  factory :father, class: ProfileIndividual do
    role 'father'
    association :job_domain
  end
end
