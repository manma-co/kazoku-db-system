class CommonMailer < ActionMailer::Base

  # Development の時はyoshihito.meからとりあえず送る設定。
  if Rails.env == 'development'
    default from: 'manma <info@yoshihito.me>'
  else
    default from: 'manma <info@manma.co>'
  end

  layout 'mailer'

  # マッチング成立時に使う。
  def matched_email(contact)
    @contact = contact
    @user = @contact.user
    mail(to: @contact.email_pc, subject: '【重要 / 家族留学】マッチングしました')
  end


  # 家庭向けに家族留学希望者がいることを知らせるメール。
  def request_email_to_family(title, body, user, hash, root_url, log)

    # Disable memory pointer with dup method.
    mail_body = body.dup

    mail = user.contact.email_pc

    # Use user to show user name for each email.
    @user = user

    # Create and insert hash link with user email
    link = root_url + 'request/' + hash + '?email=' + mail
    mail_body.sub!(/\[manma_request_link\]/, link)

    # Replace user name.
    mail_body.sub!(/\[manma_user_name\]/, @user.name)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => mail,
        :subject => title,
        :body_text => mail_body,
        :request_log => log,
        :retry_count => 0,
        :sent_status => false,
        :email_type => Settings.email_type.request
    )
    @body = mail_body
    # Send Grid を使ってmanma.coからメールを送るようにする。
    mail(to: mail, subject: title)

    # Update email queue status
    queue = EmailQueue.where(to_address: mail, request_log: log).limit(1)
    queue.update(sent_status: true, time_delivered: Time.now)
  end


  # マッチング成立時にmanmaに送るメール。
  # 電話の日付が入る場合もあり
  def notify_to_manma(tel_time, event)
    @tel_time = tel_time
    @event = event unless event.nil?
    @user = User.find(event.user_id)

    title = '【重要】マッチング成立のお知らせ'
    title || title += @event.start_time.strftime('%Y年%m月%d日')

    # Send a mail
    mail(to: 'info@manma.co', subject: title)

    body = MailerBody.notify_to_manma(@tel_time, @event, @user)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => 'info@manma.co',
        :subject => title,
        :body_text => body,
        :request_log => RequestLog.find(@event.request_log_id),
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'notify_to_manma',
        :time_delivered => Time.now
    )
  end

  # マッチング成立時に家庭に向けて送る
  def notify_to_family_matched(event)
    @user = User.find(event.user_id)
    request_log = RequestLog.find(event.request_log_id)
    mail = @user.contact.email_pc
    title = '【manma】家族留学を受け入れてくださりありがとうございます'
    @student = request_log
    @event = EventDate.find_by(request_log_id: request_log.id)

    # Send a mail
    mail(to: mail, subject: title)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => mail,
        :subject => title,
        :body_text => '',
        :request_log => request_log,
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'notify_to_family_matched',
        :time_delivered => Time.now
    )
  end

  # マッチング成立時に参加者に向けて送る
  def notify_to_candidate(event)
    @event = event
    @log = RequestLog.find(event.request_log_id)
    @user = User.find(event.user_id)
    title = "【manma】家族留学のマッチングが成立いたしました"

    # Send a mail
    mail(to: @log.email, subject: title)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => @log.email,
        :subject => title,
        :body_text => '',
        :request_log => @log,
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'notify_to_candidate',
        :time_delivered => Time.now
    )
  end

  # マッチング開始時に参加者に向けて送る
  def matching_start(email)
    # Send a mail
    mail(to: email, subject: '【manma】家族留学の打診を開始いたしました')

    body = MailerBody.matching_start

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => email,
        :subject => '【manma】家族留学の打診を開始いたしました',
        :body_text => body,
        :request_log => RequestLog.first,
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'matching_start',
        :time_delivered => Time.now
    )
  end

  # マッチングを断った場合に家庭に送る
  def deny(user)
    @user = user
    title = "【manma】家族留学受け入れ可否のご回答をありがとうございました"
    # Send a mail
    mail(to: user.contact.email_pc, subject: title)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => user.contact.email_pc,
        :subject => title,
        :body_text => '',
        :request_log => RequestLog.first,
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'deny',
        :time_delivered => Time.now
    )
  end

  # 再打診候補日程をもらうメール
  def readjustment_to_candidate(log)

    @log = log
    title = "【要返信】家族留学の再打診に関しまして"

    # Send a mail
    mail(to: log.email, subject: title)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => log.email,
        :subject => title,
        :body_text => '',
        :request_log => log,
        :retry_count => 0,
        :sent_status => true,
        :email_type => Settings.email_type.readjustment,
        :time_delivered => Time.now
    )

  end


  # 再打診メールを info@manma.co にもお知らせする。
  def readjustment_to_manma(log)

    @log = log
    title = "自動送信 →【要返信】家族留学の再打診に関しまして"

    # Send to manma
    mail(to: 'yoshihito522@gmail.com', subject: title)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => 'info@manma.co',
        :subject => title,
        :body_text => '',
        :request_log => log,
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'readjustment_to_manma',
        :time_delivered => Time.now
    )
  end

  include ApplicationHelper

  # リマインダーメールの送信に使う
  def reminder_three_days(user, log)

    root = default_host_url
    @user = user
    @log = log
    @days = RequestDay.where(request_log: log)
    @url = root + 'request/' + @log.hashed_key + '?email=' + user.contact.email_pc
    title = "【リマインド】家族留学受け入れのお願い"

    # Send a mail
    mail(to: user.contact.email_pc, subject: title)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => user.contact.email_pc,
        :subject => title,
        :body_text => '',
        :request_log => log,
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'reminder_three_days',
        :time_delivered => Time.now
    )

  end

end
