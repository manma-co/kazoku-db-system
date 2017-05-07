# Preview all emails at http://localhost:3000/rails/mailers/common_mailer
class CommonMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/common_mailer/matched_email
  def matched_email
    contact = Contact.first
    CommonMailer.matched_email(contact)
  end
end
