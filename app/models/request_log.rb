class RequestLog < ApplicationRecord
  has_many :request_day, dependent: :destroy

  validates :hashed_key, presence: true
end
