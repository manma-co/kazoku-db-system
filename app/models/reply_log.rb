class ReplyLog < ApplicationRecord
  belongs_to :user
  belongs_to :request_log
end
