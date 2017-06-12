# Preview all emails at http://localhost:3000/rails/mailers/common_mailer
class CommonMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/common_mailer/matched_email
  def matched_email
    contact = Contact.first
    CommonMailer.matched_email(contact)
  end

  # http://localhost:3000/rails/mailers/common_mailer/matched_email_to_family
  def matched_email_to_family
    title = '【要返信】家族留学受け入れのお願い'
    body = '受け入れ家庭のみなさまへ こんにちは、manmaです。 いつも大変お世話になっております。 家族留学を受け入れていただきたく、ご連絡いたしました。 登録していただいている学生の方で、ぜひ家族留学してみたいという方がいらっしゃいます。 下記打診内容をご確認いただき、受け入れ可能な日程がございましたら、＜受け入れ日程・時間＞を明記の上、こちらのメールにご返信ください。 ○ 参加者プロフィール 氏名：入力されていません 所属：入力されていません 最寄り駅：入力されていません 参加動機：入力されていません 【候補日】 ＝＝＝＝＝＝返信用フォーマット＝＝＝＝＝＝＝＝ ●受け入れ可能 or 不可 ●受け入れ可能日程： ●受け入れ可能時間： ※ 家族留学の時間は５時間以上でご検討ください。 ●備考： ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ 連絡先： kubo@manma.co（担当：久保） ＊ 注意事項＊ ・ 受け入れてくださる方はこちらのメールに返信という形でお願いいたします。その際にお手数ですが＜受け入れてくださる日程・時間＞を忘れずにご記入ください。 ・ こちらのシステムは返信が最も早かったご家庭に家族留学させていただきます。ご返信いただいても前に他のご家庭から返信が来ている場合はキャンセルとなります。ご了承ください。 何かご不明な点がございましたら、kubo@manma(担当：久保)までご連絡ください。 manma'
    users = User.limit(3)
    CommonMailer.matched_email_to_family(title, body, users)
  end

  # http://localhost:3000/rails/mailers/common_mailer/notify_to_manma
  def notify_to_manma
    event = EventDate.first
    tel_time = '2017-07-07 20:00:00'
    CommonMailer.notify_to_manma(tel_time, event)
  end
end
