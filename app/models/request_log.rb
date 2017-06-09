class RequestLog < ApplicationRecord
  has_many :request_day, dependent: :destroy
  has_many :reply_log, dependent: :destroy
  has_one :event_date, dependent: :destroy

  validates :hashed_key, presence: true
end
