# Preview all emails at http://localhost:3000/rails/mailers/common_mailer
class CommonMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/common_mailer/matched_email
  def matched_email
    contact = Contact.first
    CommonMailer.matched_email(contact)
  end

  # http://localhost:3000/rails/mailers/common_mailer/request_email_to_family
  def request_email_to_family
    title = '【要返信】家族留学受け入れのお願い'
    body = <<-EOS
 
※本メールはBccでお送りしております


こんにちは、manmaです。
いつも大変お世話になっております。
 
家族留学を受け入れていただきたく、ご連絡いたしました。
[manma_user_name]さまのお宅への家族留学を希望されている方がいらっしゃいます。 

下記打診内容をご確認いただき、受け入れ可能な日程がございましたら
＜受け入れ日程・時間＞を明記の上、こちらのメールにご返信ください。

 
○  参加者プロフィール
氏名：[manma_template_student_name]
所属：[manma_template_student_belongs_to]
最寄り駅：[manma_template_station]
参加動機：[manma_template_motivation]
 
【候補日】
[manma_template_dates]
 
こちらのURLからご回答ください。
[manma_request_link]

 
＊  注意事項＊
・  受け入れてくださる方はこちらのメールに返信という形でお願いいたします。その際にお手数ですが＜受け入れてくださる日程・時間＞を忘れずにご記入ください。
・  複数のご家庭に打診をさせていただいているため、どちらかのご家庭から受け入れ許可をいただいた時点でURLが無効となります。ご了承ください。
 

何かご不明な点がございましたら、kubo@manma(担当：久保)までご連絡ください。

 
manma
    EOS
    user = User.first
    hash = '8k1hl1gm93joqhjg5wv865wv'
    root_url = 'http://localhost:8080'
    log = RequestLog.first
    CommonMailer.request_email_to_family(title, body, user, hash, root_url, log)
  end

  # http://localhost:3000/rails/mailers/common_mailer/notify_to_manma
  def notify_to_manma
    event = EventDate.first
    tel_time = ["2017-07-20 10:00", "", ""]
    CommonMailer.notify_to_manma(tel_time, event)
  end

  # http://localhost:3000/rails/mailers/common_mailer/notify_to_candidate
  def notify_to_candidate
    event = EventDate.first
    CommonMailer.notify_to_candidate(event)
  end

  def matching_start
    email = "info@example.com"
    CommonMailer.matching_start(email)
  end

  def deny
    user = User.first
    CommonMailer.deny(user)
  end

  # http://localhost:3000/rails/mailers/common_mailer/reminder_three_days
  def reminder_three_days
    user = User.first
    log = RequestLog.second
    CommonMailer.reminder_three_days(user, log)
  end

end
