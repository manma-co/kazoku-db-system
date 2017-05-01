class JobDomain < ApplicationRecord
  belongs_to :profile_individual
  has_many :profile_individuals, dependent: :destroy
end
