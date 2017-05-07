class CommonMailer < ActionMailer::Base
  # default from: 'Manma <info@manma.co>'
  default from: 'Manma <info@yoshihito.me>'
  layout 'mailer'

  def matched_email(contact)
    @contact = contact
    @user = @contact.user
    mail(to: @contact.email_pc, subject: '【重要 / 家族留学】マッチングしました')
  end

  def matched_email_to_family(title, body, users)
    @users = users
    @body = body
    mails = ''
    @users.each do |user|
      mails += user.contact.email_pc + ', '
    end
    mail(to: mails, subject: title)
  end

end
