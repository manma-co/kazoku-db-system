class ProfileFamily < ApplicationRecord
  belongs_to :user
  has_many :profile_individuals, dependent: :destroy
end
