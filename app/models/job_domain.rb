class JobDomain < ApplicationRecord
  has_many :profile_individuals

  enum job_domains: {
    "#{Settings.job_domain.str.homemaker}": 1,
    "#{Settings.job_domain.str.maker}": 2,
    "#{Settings.job_domain.str.restaurant}": 3,
    "#{Settings.job_domain.str.store}": 4,
    "#{Settings.job_domain.str.retail}": 5,
    "#{Settings.job_domain.str.finance}": 6,
    "#{Settings.job_domain.str.media}": 7,
    "#{Settings.job_domain.str.it}": 8,
    "#{Settings.job_domain.str.infrastructure}": 9,
    "#{Settings.job_domain.str.real_state}": 10,
    "#{Settings.job_domain.str.medical}": 11,
    "#{Settings.job_domain.str.education}": 12,
    "#{Settings.job_domain.str.consultant}": 13,
    "#{Settings.job_domain.str.public}": 14,
    "#{Settings.job_domain.str.self}": 15,
    "#{Settings.job_domain.str.npo}": 16
  }
end
