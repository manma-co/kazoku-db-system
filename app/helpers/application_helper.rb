module ApplicationHelper
  # 日付をフォーマットする
  # @param [date] date Date型の情報
  # @return [String] フォーマットされた日付データ
  def formatted_date(date)
    date&.strftime('%Y年%m月%d日')
  end

  def default_host_url
    "https://manma-system.herokuapp.com/"
  end
end
