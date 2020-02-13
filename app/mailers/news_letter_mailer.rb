class NewsLetterMailer < ApplicationMailer
  # Development の時はyoshihito.meからとりあえず送る設定。
  if Rails.env.development?
    default from: 'manma <localhost:3000>'
  else
    default from: 'manma <info@manma.co>'
  end

  add_template_helper(TextHelper)

  # ニュースレターを送信する
  def send_news_letter(news_letter, bcc_address)
    @body = news_letter.content
    subject = news_letter.subject
    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: 'info@manma.co',
      bcc_address: bcc_address,
      subject: subject,
      body_text: '',
      study_abroad: StudyAbroad.first,
      retry_count: 0,
      sent_status: false,
      email_type: 'send_news_letter'
    )

    mail(to: 'info@manma.co', bcc: bcc_address, subject: subject)
    queue = EmailQueue.where(
      to_address: 'info@manma.co',
      study_abroad: StudyAbroad.first,
      subject: subject,
      sent_status: false,
      email_type: 'send_news_letter'
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end
end
