class RequestLog < ApplicationRecord
  has_many :request_day, dependent: :destroy
  has_many :reply_log, dependent: :destroy
  has_many :email_queue, dependent: :destroy
  has_one :event_date, dependent: :destroy
  has_one :reminder, dependent: :destroy

  # 10日間経ったかを確認する
  def self.ten_days_over
    logs = RequestLog.includes(:event_date)
    logs.each do |log|
      # イベントが成立していなくて、10以上たったリクエストを探す。
      # Email queue を利用して、すでに送信しているかどうかをチェックする。
      queue = EmailQueue.find_by(request_log: log, email_type: "readjustment_to_candidate")
      if log.event_date == nil && log.created_at + 7.days < Time.now && queue.nil?
        # 参加希望者に対して再打診をするかどうかのメールを送信
        CommonMailer.readjustment_to_candidate(log).deliver_now if log.id > 1
      end
    end
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

      # Check remind status.
      if log.event_date == nil && log.created_at + 3.days < Time.now && log.reminder == nil

        # リマインドメールを送る家庭を探すために、ReplyLog から何もアクションをしていない家庭を探す。
        # すべての送信履歴を参照
        mail_queues = EmailQueue.where(request_log_id: log.id, email_type: "request_email_to_family").select(:to_address)

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
