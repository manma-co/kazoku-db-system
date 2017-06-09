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
  def request_email_to_family(title, body, users)
    @users = users
    @body = body
    mails = ''
    @users.each do |user|
      mails += user.contact.email_pc + ', '
    end

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => 'info@manma.co',
        :bcc_address => mails,
        :subject => title,
        :body_text => body,
        :retry_count => 0,
        :sent_status => 0,
        :email_type => 'request_email_to_family'
    )

    # Send Grid を使ってmanma.coからメールを送るようにする。
    mail(to: 'info@manma.co', bcc: mails, subject: title)

    # Update email queue status
    queue = EmailQueue.where(bcc_address: mails).order('created_at desc').limit(1)
    queue.update(sent_status: true, time_delivered: Time.now)
  end

  # info@manma.co にメールを送る設定。
  def notify_to_manma(title, body)
    @body = body
    mail(to: 'info@manma.co', subject: title)
  end

  def matching_start(email)
    mail(to: email, subject: '【manma】家族留学の打診を開始いたしました')
  end


end
