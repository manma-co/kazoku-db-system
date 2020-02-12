# TODO: テーブル名をStudyAbroad(留学) に変更する
class RequestLog < ApplicationRecord
  has_many :request_day, dependent: :destroy
  has_many :reply_log, dependent: :destroy
  has_many :email_queue, dependent: :destroy
  has_one :event_date, dependent: :destroy

  def is_rejected_all?
    self.reply_log.where(answer_status: :rejected).count == self.reply_log.count
  end

  def is_matched?
    self.reply_log.where(answer_status: :accepted).exists? || self.reply_log.where(result: true).exists?
  end

  def is_after_seven_days?
    Date.current - self.created_at.to_date > 7
  end

  def is_already_replied_by_user?(user_id)
    self.reply_log.where(user_id: user_id).where.not(answer_status: :no_answer).exists?
  end

  # 留学リクエスト中の留学情報を取得する
  def self.requesting(hashed_key)
    request_log = RequestLog.includes(:reply_log).find_by(hashed_key: hashed_key)
    return nil if request_log.nil?

    return nil if request_log.is_matched? || request_log.is_after_seven_days?

    request_log
  end

  # 7日前のRequestQueueを取得する(readjustmentでないEmailQueueを持っている)
  # 7日経ってもマッチングしなかった場合は、再打診するかどうか確認するメールを送信する
  def self.get_all_seven_days_before_for_remind
    request_logs = []
    RequestLog.includes(:event_date).where(event_dates: { id: nil }, created_at: 7.days.ago.all_day).each do |request_log|
      request_logs << request_log
    end
    request_logs
  end

  def self.get_all_three_days_before_for_remind
    request_logs = []
    RequestLog.includes(:event_date, reply_log: { user: :contact }).where(event_dates: { id: nil }, created_at: 3.days.ago.all_day).each do |request_log|
      request_logs << request_log
    end
    request_logs
  end
end
