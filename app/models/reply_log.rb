class ReplyLog < ApplicationRecord
  belongs_to :user
  belongs_to :study_abroad

  enum answer_status: { no_answer: 0, accepted: 1, rejected: 2 }
end
