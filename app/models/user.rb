class User < ApplicationRecord
  has_one :profile_family, dependent: :destroy
  has_one :location, dependent: :destroy
  has_one :contact, dependent: :destroy
  has_many :event_dates, dependent: :destroy
  has_many :reply_log, dependent: :destroy

  validates :name, presence: true, length: {maximum: 20}
  validates :gender, presence: true
end
