class NewsLetter < ApplicationRecord
  validates :subject, presence: true
  validates :content, presence: true



  # メール送信のスケジュールタスクを実行する機能
  def send_news_letter

    # TODO: 送信すべきニュースレターが存在するかをチェックする

    # TODO: メールを送信する

  end

end
