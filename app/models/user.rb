class User < ApplicationRecord
  has_one :profile_family, dependent: :destroy
  has_one :location, dependent: :destroy
  has_one :contact, dependent: :destroy
  has_many :event_dates, dependent: :destroy
  has_many :reply_log, dependent: :destroy

  validates :name, presence: true, length: {maximum: 20}
  validates :gender, presence: true


  # 働き方の文字列を取得する
  def job_style_str
    job_style = self.profile_family.job_style
    if job_style == Settings.job_style.both
      Settings.job_style.str.both
    elsif job_style == Settings.job_style.both_single
      Settings.job_style.str.both_single
    elsif job_style == Settings.job_style.homemaker
      Settings.job_style.str.homemaker
    end
  end

end
