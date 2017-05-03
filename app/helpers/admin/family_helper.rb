module Admin::FamilyHelper

  # 働き方の文字列を取得する
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
  def is_male_ok_str(is_male_ok)
    if is_male_ok == Settings.is_male.ok
      'OK'
    elsif is_male_ok == Settings.is_male.ng
      'NG'
    end
  end

end
