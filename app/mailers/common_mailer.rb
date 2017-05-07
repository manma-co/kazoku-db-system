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
  def request_email_to_family(title, body, users)
    @users = users
    @body = body
    mails = ''
    @users.each do |user|
      mails += user.contact.email_pc + ', '
    end
    # Development の時はyoshihito.meからとりあえず送る設定。
    # Send Grid を使ってmanma.coからメールを送るようにする。
    if Rails.env == 'development'
      mail(to: mails, from: 'manma <info@yoshihito.me>', subject: title)
    else
      mail(to: mails, subject: title)
    end
  end

  # info@manma.co にメールを送る設定。
  def notify_to_manma(title, body)
    @body = body
    mail(to: 'info@manma.co', subject: title)
  end

end
