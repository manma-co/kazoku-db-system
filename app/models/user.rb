class User < ApplicationRecord

  has_one :profile_family, dependent: :destroy
  has_one :location, dependent: :destroy
  has_one :contact, dependent: :destroy

  validates :name, presence: true, length: {maximum: 20}
  validates :gender, presence: true
end
