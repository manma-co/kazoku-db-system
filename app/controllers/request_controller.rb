class RequestController < ApplicationController

  layout 'public'

  def confirm
    @log = RequestLog.find_by(hashed_key: params[:id])
    # Check exist
    return redirect_to deny_path if @log.nil?

    @days = @log.request_day unless @log.nil?
    contact = Contact.find_by(email_pc: params[:email])
    @user = contact.user if contact

    if @user
      # 回答済みの場合はリダイレクト
      reply = ReplyLog.find_by(request_log_id: @log.id, user_id: @user.id)
      return redirect_to deny_path if reply

      # すでにマッチングが成立していたらリダイレクト
      event = EventDate.find_by(request_log_id: @log)
      return redirect_to sorry_path if event

    else
      # ユーザーが存在しなかったらリダイレクト
      redirect_to deny_path
    end
  end

  def reply
    @log = RequestLog.find_by(hashed_key: params[:id])
    @days = @log.request_day
    @user = Contact.find_by(email_pc: params[:email]).user
    @event = EventDate.new
  end

  def event_create
    # Parse date and time
    selected_date = event_params[:event_time]
    day = selected_date.split(' ')[0]
    s_time = day + ' ' + selected_date.split(' ')[1]
    e_time = day + ' ' + selected_date.split(' ')[3]

    # Get dates
    log = RequestLog.find(event_params[:request_log_id])
    user = User.find(event_params[:user_id])

    event = user.event_dates.build
    event.request_log = log
    event.hold_date = day
    event.start_time = s_time.to_time(:utc)
    event.end_time = e_time.to_time(:utc)
    event.meeting_place = event_params[:meeting_place]
    event.is_first_time = event_params[:is_first_time] || false
    event.emergency_contact = event_params[:emergency_contact]
    event.event_time = event_params[:event_time]
    event.information = event_params[:information]

    if event.save!
      session[:event] = event.id

      # Send email to manma.
      CommonMailer.notify_to_manma(params[:tel_time], event).deliver_now

      # Send email to family.
      CommonMailer.notify_to_family_matched(event).deliver_now

      # Send email to candidate.
      CommonMailer.notify_to_candidate(event).deliver_now

      # Save new reply log
      user.reply_log.create!(request_log: log, result: true)

      # Write data to spread sheet
      row = [
        DateTime.current.strftime('%Y/%m/%d %H:%M:%S'),
        'manma-system',
        user.name,  # 家庭代表者氏名

        event.emergency_contact,  # 家庭連絡先
        'はい',     # 受け入れるか？
        log.name,   # 家族留学者氏名
        log.emergency,  # 家族留学者連絡先
        '',
        '',
        '',
        '',
        '', # 受け入れ家庭の家族構成
        event.hold_date.strftime('%Y/%m/%d'), # 実施日時
        event.start_time.strftime('%H:%M:%S'),
        event.end_time.strftime('%H:%M:%S'),
        event.meeting_place
      ]
      authorize, credentials = Google::SpreadSheetAuthorizeService.do(request, ENV['SPREAD_SHEET_AUTH_UNIQUE_ID'])
      Google::SpreadSheetWriteService.do(credentials, row)

      redirect_to thanks_path
    else
      redirect_to reply_path
    end
  end

  def deny
    # Save reply log to DB
    if params[:email] && params[:log_id]
      user = Contact.find_by(email_pc: params[:email]).user
      reply = ReplyLog.new(
          user: user,
          result: false,
          request_log_id: params[:log_id]
      )

      reply.save!
      # Send mail to user.
      CommonMailer.deny(user).deliver_now
      redirect_to :deny
    end
  end

  def thanks
    if session[:event]
      event_id = session[:event]
      @event = EventDate.find(event_id)
      session[:event] = nil
    else
      redirect_to deny_path
    end
  end

  def sorry
  end

  private

  def event_params
    params.require(:event_date).permit(
                                   :user_id,
                                   :request_log_id,
                                   :meeting_place,
                                   :emergency_contact,
                                   :is_first_time,
                                   :information,
                                   :event_time
    )
  end

end
