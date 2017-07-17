class NewsLetterMailer < ApplicationMailer

  # ニュースレターを送信する
  def send_news_letter(news_letter, bcc_address)
    @body = news_letter.body
    subject = @news_letter.subject
    mail(to: 'info@manma.co', bcc: bcc_address, subject: subject)

    # Insert to DB
    EmailQueue.create!(
        :sender_address => 'info@manma.co',
        :to_address => 'info@manma.co',
        :bcc_address => bcc_address,
        :subject => subject,
        :body_text => '',
        :request_log => 0,
        :retry_count => 0,
        :sent_status => true,
        :email_type => 'send_news_letter',
        :time_delivered => Time.now
    )
  end
end
