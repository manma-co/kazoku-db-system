class RequestLog < ApplicationRecord
  has_many :request_day, dependent: :destroy
end
