module Admin::FamilyHelper
  # 働き方の文字列を取得する
  # @param [int] job_style 働き方ステータス
  # @return [String] 働き方文字列
  def job_style_str(job_style)
    if job_style == Settings.job_style.both
      Settings.job_style.str.both
    elsif job_style == Settings.job_style.both_single
      Settings.job_style.str.both_single
    elsif job_style == Settings.job_style.homemaker
      Settings.job_style.str.homemaker
    end
  end

  # 男性OK or NG文字列を取得する
  # @param [bool] is_male_ok 男性の参加者を許可するか
  # @return [String] OK or NG
  def is_male_ok_str(is_male_ok)
    if is_male_ok == Settings.is_male.ok
      'OK'
    elsif is_male_ok == Settings.is_male.ng
      'NG'
    end
  end

  # SNS上での写真使用に関する文字列を取得する
  # @param [int] is_photo_ok 写真の使用を許可するか
  # @return [String] 写真使用に関する文字列
  def is_photo_ok_str(is_photo_ok)
    if is_photo_ok == Settings.is_photo.ng
      Settings.is_photo.str.ng
    elsif is_photo_ok == Settings.is_photo.ok
      Settings.is_photo.str.ok
    elsif is_photo_ok == Settings.is_photo.caution
      Settings.is_photo.str.caution
    end
  end

  def is_report_ok_str(is_report_ok)
    if is_report_ok == Settings.is_report.ng
      Settings.is_photo.str.ng
    elsif is_report_ok == Settings.is_report.ok
      Settings.is_report.str.ok
    elsif is_report_ok == Settings.is_report.caution
      Settings.is_report.str.caution
    end
  end
end
