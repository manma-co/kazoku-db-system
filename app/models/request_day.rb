class RequestDay < ApplicationRecord
  belongs_to :request_log

  validates :request_log_id, presence: true

end
