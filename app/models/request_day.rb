class RequestDay < ApplicationRecord
  belongs_to :study_abroad

  validates :study_abroad_id, presence: true
end
