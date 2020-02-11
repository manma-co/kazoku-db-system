# TODO: テーブル名をStudyAbroad(留学) に変更する
class RequestLog < ApplicationRecord
  has_many :request_day, dependent: :destroy
  has_many :reply_log, dependent: :destroy
  has_many :email_queue, dependent: :destroy
  has_one :event_date, dependent: :destroy
  has_one :reminder, dependent: :destroy

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
    RequestLog.includes(:event_date, :email_queue).where(event_dates: { id: nil }, created_at: 7.days.ago.all_day).each do |request_log|
      request_logs << request_log if request_log.email_queue.where(email_type: Settings.email_type.readjustment).size == 0
    end
    request_logs
  end

  # 3日たった時にリマインドメールを送る
  def self.three_days_reminder
    # Find families to send a reminder email.
    # The way how it works is
    # 1. Find request log that has not been approved, using event table.

    logs = RequestLog.includes(:event_date)
    logs.each do |log|

      # Check if there is event date.
      # Execute reminder mail functions in case of event date nil
      # RequestLog の中から EventDate のないものを探す。
      # 且つ3日たち、リマインドメールを送っていない場合

      # Check remind statu
      past_three_days = log.created_at + 3.days < Time.now
      if log.event_date == nil && past_three_days && log.reminder == nil

        # リマインドメールを送る家庭を探すために、ReplyLog から何もアクションをしていない家庭を探す。
        # すべての送信履歴を参照
        mail_queues = EmailQueue.where(request_log_id: log.id, email_type: Settings.email_type.request).select(:to_address)

        # 返信履歴（ReplyLog）の中に、送信履歴（EmailQueue）から割り出した家庭が存在していないものを取り出す。
        # つまりは、返信していない家庭の割り出し。
        mail_queues.each do |mail_queue|
          contact = Contact.find_by(email_pc: mail_queue.to_address)
          rl = ReplyLog.find_by(request_log_id: log.id, user_id: contact.user_id)

          # Send reminder.
          CommonMailer.reminder_three_days(contact.user, log).deliver_now if rl.nil?
        end

        # Insert to DB to check reminder was send.
        Reminder.create!(request_log: log)
      end
    end
  end

end
