class NewsLetter < ApplicationRecord
  validates :subject, presence: true
  validates :content, presence: true


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
    news_letter = NewsLetter.
        where('distribution <= ? AND is_save = ? AND is_sent = ?', Time.now, false, false).
        where('is_monthly = ? ', true).
        where('send_to = ?', 'participant').first
    # nil check
    return if news_letter.nil?

    # すべての参加者情報を取得する
    # TODO: 受信設定に応じて取得するユーザーを変更する。
    users = Participant.all
    bcc_address = ""
    users.each do |user|
      bcc_address += user.email + ", "
    end

    p "bcc_address: #{bcc_address}"
    p "content: #{news_letter.content}"
    # メールを送信する
    NewsLetterMailer.send_news_letter(news_letter, bcc_address)

    # 送信済みにする
    news_letter.update(is_sent: true)
  end


  # メール送信のスケジュールタスクを実行する機能
  # 家庭にメールを一斉送信
  def self.send_news_letter

    # 送信すべきニュースレターが存在するかをチェックする
    news_letter = NewsLetter.
        where('distribution <= ? AND is_save = ? AND is_sent = ?', Time.now, false, false).
        where('is_monthly = ? ', false).
        where('send_to = ?', 'family').first

    # nil check
    return if news_letter.nil?

    # すべての参加者情報を取得する
    # TODO: 受信設定に応じて取得するユーザーを変更する。
    users = User.all
    bcc_address = ""
    users.each do |user|
      bcc_address += user.contact.email_pc + ", "
    end

    # メールを送信する
    NewsLetterMailer.send_news_letter(news_letter, bcc_address)

    # 送信済みにする
    news_letter.update("is_sent = true")
  end

end
