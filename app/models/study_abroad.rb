class StudyAbroad < ApplicationRecord
  has_many :request_day, dependent: :destroy
  has_many :study_abroad_request, dependent: :destroy
  has_many :email_queue, dependent: :destroy
  has_one :event_date, dependent: :destroy

  def is_rejected_all?
    study_abroad_request.where(answer_status: :rejected).count == study_abroad_request.count
  end

  def is_matched?
    study_abroad_request.where(answer_status: :accepted).exists? || study_abroad_request.where(result: true).exists?
  end

  def is_after_seven_days?
    Date.current - created_at.to_date > 7
  end

  def is_already_replied_by_user?(user_id)
    study_abroad_request.where(user_id: user_id).where.not(answer_status: :no_answer).exists?
  end

  # 留学リクエスト中の留学情報を取得する
  def self.requesting(hashed_key)
    study_abroad = StudyAbroad.includes(:study_abroad_request).find_by(hashed_key: hashed_key)
    return nil if study_abroad.nil?

    return nil if study_abroad.is_matched? || study_abroad.is_after_seven_days?

    study_abroad
  end

  # 7日前のRequestQueueを取得する(readjustmentでないEmailQueueを持っている)
  # 7日経ってもマッチングしなかった場合は、再打診するかどうか確認するメールを送信する
  def self.all_seven_days_before_for_remind
    study_abroads = []
    StudyAbroad.includes(:event_date).where(event_dates: { id: nil }, created_at: 7.days.ago.all_day).find_each do |study_abroad|
      study_abroads << study_abroad
    end
    study_abroads
  end

  def self.all_three_days_before_for_remind
    study_abroads = []
    StudyAbroad.includes(:event_date, study_abroad_request: { user: :contact }).where(event_dates: { id: nil }, created_at: 3.days.ago.all_day).find_each do |study_abroad|
      study_abroads << study_abroad
    end
    study_abroads
  end
end
