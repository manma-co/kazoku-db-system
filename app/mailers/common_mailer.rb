class CommonMailer < ActionMailer::Base
  default from: 'Manma <info@manma.co>'
  layout 'mailer'


  def matched_email(contact)
    @contact = contact
    @user = @contact.user
    mail(to: @contact.email_pc, subject: '【重要 / 家族留学】マッチングしました')
  end

end
