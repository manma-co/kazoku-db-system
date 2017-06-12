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
    queue = EmailQueue.where(to_address: mail).order('created_at desc').limit(1)
    queue.update(sent_status: true, time_delivered: Time.now)
  end


  # info@manma.co にメールを送る設定。
  def notify_to_manma(title, body)
    @body = body
    if Rails.env == 'development'
      mail(to: 'info@example.com', from: 'manma <info@yoshihito.me>', subject: 'テスト送信' + title)
    else
      mail(to: 'info@manma.co', subject: title)
    end
  end
end
