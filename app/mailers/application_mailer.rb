class ApplicationMailer < ActionMailer::Base
  default from: 'manma <info@manma.co>'
  default bcc: 'info@manma.co'
  layout 'mailer'
end
