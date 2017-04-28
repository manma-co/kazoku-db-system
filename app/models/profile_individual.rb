class ProfileIndividual < ApplicationRecord
  belongs_to :profile_family
  has_one :job_domain
end
