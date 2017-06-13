class CommonMailer < ActionMailer::Base
  default from: 'manma <info@manma.co>'
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
        :email_type => 'request_email_to_family'
    )
    @body = mail_body
    # Development の時はyoshihito.meからとりあえず送る設定。
    # Send Grid を使ってmanma.coからメールを送るようにする。
    if Rails.env == 'development'
      mail(to: mail, from: 'manma <info@yoshihito.me>', subject: 'テスト送信' + title)
    else
      mail(to: mail, subject: title)
    end

    # Update email queue status
    queue = EmailQueue.where(to_address: mail, request_log: log).limit(1)
    queue.update(sent_status: true, time_delivered: Time.now)
  end


  # info@manma.co にマッチング成立時に送るメール。
  # 電話の日付が入る場合もあり
  def notify_to_manma(tel_time, event)
    @tel_time = tel_time
    @event = event unless event.nil?

    title = '【重要】マッチング成立のお知らせ。'
    title || title += @event.start_time.strftime('%Y年%m月%d日')

    if Rails.env == 'development'
      mail(to: 'info@example.com', from: 'manma <info@yoshihito.me>', subject: 'テスト送信' + title)
    else
      mail(to: 'info@manma.co', subject: title)
    end

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => 'info@manma.co',
        :subject => title,
        :body_text => '',
        :request_log => RequestLog.first,
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'notify_to_manma',
        :time_delivered => Time.now
    )

  end

  # マッチング成立時に家庭に向けて送る
  def notify_to_family_matched(event)
    @user = User.find(event.user_id).first
    mail = @user.contact.email_pc
    title = ''

    mail(to: 'info@manma.co', subject: title)
  end

end
