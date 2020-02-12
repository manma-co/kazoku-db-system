class NewsLetter < ApplicationRecord
  validates :subject,      presence: true
  validates :content,      presence: true
  validates :distribution, presence: true

  def send_to_ja
    send_to == 'participant' ? '参加者' : '家庭'
  end

  # TODO: scope がうまく使えないので調査
  # 送信可能なメールを探す（保存ではないもの）
  scope :can_be_sent, -> {
    where('distribution <= ? AND is_save = ? AND is_sent = ?', Time.now, false, false)
  }

  # 月一回送信かのチェック
  scope :monthly_news, -> {
    where('is_monthly = ? ', true)
  }

  # 家庭向け
  scope :to_family, -> {
    where('send_to = ?', 'family')
  }

  # 参加者向け
  scope :to_participant, -> {
    where('send_to = ?', 'participant')
  }

  # 月に1回学生会員にメールを送信
  scope :monthly_news, -> {
    can_be_sent.monthly_news.to_participant
  }

  # 家庭にメールを一斉送信
  scope :news_letter, -> {
    can_be_sent.to_family
  }

  # メール送信のスケジュールタスクを実行する機能
  # 月に1回学生会員にメールを送信
  def self.monthly_news_letter
    # 送信すべきニュースレターが存在するかをチェックする
    news_letter = NewsLetter
                  .where('is_save = ?', false)
                  .where('is_monthly = ? ', true)
                  .where('distribution <= ?', Time.now)
                  .where('send_to = ?', 'participant').first
    # nil check
    return if news_letter.nil?

    # すべての参加者情報を取得する
    # TODO: 受信設定に応じて取得するユーザーを変更する。
    users = Participant.all
    bcc_address = ''
    users.each do |user|
      bcc_address += user.email + ', '
    end

    # manma.co 宛にも送信
    bcc_address += 'info@manma.co'

    # メールを送信する
    NewsLetterMailer.send_news_letter(news_letter, bcc_address).deliver_now

    # 配信予定日を翌月にする。
    # 送信済みにする
    news_letter.update(
      is_sent: true,
      distribution: news_letter.distribution.next_month
    )
  end

  # メール送信のスケジュールタスクを実行する機能
  # メールを一斉送信
  def self.send_news_letter
    # 送信すべきニュースレターが存在するかをチェックする
    news_letter = NewsLetter
                  .where('distribution <= ? AND is_save = ? AND is_sent = ?', Time.now, false, false)
                  .where('is_monthly = ? ', false).first

    # nil check
    return if news_letter.nil?

    # すべての参加者情報を取得する
    # メールの送信先に応じてメールアドレスの取得先を変更する。
    # TODO: 受信設定に応じて取得するユーザーを変更する。
    bcc_address = ''
    if news_letter.send_to == 'family'
      p 'Sending a news mail to family...'
      users = User.all
      users.each do |user|
        bcc_address += user.contact.email_pc + ', '
      end
    else
      p 'Sending a news mail to participants...'
      participants = Participant.all
      participants.each do |participant|
        bcc_address += participant.email + ', '
      end
    end

    # manma.co 宛にも送信
    bcc_address += 'info@manma.co'

    # メールを送信する
    NewsLetterMailer.send_news_letter(news_letter, bcc_address).deliver_now

    # 送信済みにする
    news_letter.update(is_sent: true)
  end
end
