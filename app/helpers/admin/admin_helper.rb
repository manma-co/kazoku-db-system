module Admin::AdminHelper

  def store_date_n_time(str)
    session[:date_n_time] = str
  end

  def store_user_info
    session[:student_name] = params[:student_name]
    session[:belongs_to] = params[:belongs_to]
    session[:station] = params[:station]
    session[:motivation] = params[:motivation]
  end

  def save_request_log
    # Hash key を作成
    hashed_key = SecureRandom.random_number(36**24).to_s(36).rjust(24, "0")

    # Save log data
    @log = RequestLog.create(
        :hashed_key => hashed_key,
        :name       => session[:student_name],
        :belongs    => session[:belongs_to],
        :station    => session[:station],
        :motivation => session[:motivation]
    )

    # データの重複を防ぐために一度空にする
    session[:student_name]  = nil
    session[:belongs_to]    = nil
    session[:station]       = nil
    session[:motivation]    = nil

    # 日付保存のためにデータを返却
    return @log, hashed_key

  end

  def save_request_day(log)
    br = <<-EOS

    EOS
    date_n_time = session[:date_n_time].split(br)
    date_n_time.each do |d|
      dnt = d.split(" ", 2)
      date = dnt[0]
      time = dnt[1]
      log.request_day.create!(
          :day => date,
          :time => time,
          :decided => false,
      )
    end
    # データの重複を防ぐために一度空にする
    session[:date_n_time] = nil
  end

end
