class ProfileIndividual < ApplicationRecord
  belongs_to :profile_family
  belongs_to :job_domain
end
