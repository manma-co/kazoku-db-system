class ProfileIndividual < ApplicationRecord
  has_one :job_domain, dependent: :destroy
end
