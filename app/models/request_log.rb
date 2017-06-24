class RequestLog < ApplicationRecord
  has_many :request_day, dependent: :destroy
  has_many :reply_log, dependent: :destroy
  has_many :email_queue, dependent: :destroy
  has_one :event_date, dependent: :destroy

  # 10日間経ったかを確認する
  def self.ten_days_over
    logs = RequestLog.includes(:event_date)
    logs.each do |log|
      # イベントが成立していなくて、10以上たったリクエストを探す。
      # Email queue を利用して、すでに送信しているかどうかをチェックする。
      queue = EmailQueue.find_by(request_log: log, email_type: "readjustment_to_candidate")
      if log.event_date == nil && log.created_at - 10.days < Time.now && queue.nil?
        # 参加希望者に対して再打診をするかどうかのメールを送信
        CommonMailer.readjustment_to_candidate(log).deliver_now if log.id > 1
      end
    end
  end
end
