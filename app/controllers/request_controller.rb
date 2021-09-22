class RequestController < ApplicationController
  layout 'public'

  before_action :set_study_abroad_by_hash, only: %i[confirm reply reject]
  before_action :set_user_by_email, only: %i[confirm reply reject]
  before_action :set_days, only: %i[confirm reply]

  before_action :set_study_abroad_by_id, only: [:event_create]

  # request/:id メールに添付されているURLを押下した場合に実行される
  def confirm; end

  # 受け入れる を選択した場合
  def reply
    @event = EventDate.new
  end

  def reject
    # TODO: resultを削除する
    # MEMO: study_abroad_requestが生成される前の@study_abroadが存在する可能性があるためfind_or_initialize_byにしている
    @reason = params[:reason]
    study_abroad_request = @study_abroad.study_abroad_request.find_or_initialize_by(user: @user)
    study_abroad_request.update!(user: @user, result: false, answer_status: :rejected)
    CommonMailer.deny(@study_abroad, @user, @reason).deliver_now
    # 再打診候補を参加者に送信する
    if @study_abroad.is_rejected_all?
      CommonMailer.readjustment_to_candidate(@study_abroad).deliver_now
    end
    redirect_to deny_path
  end

  def event_create
    # Parse date and time
    selected_date = event_params[:event_time]
    day = selected_date.split(' ')[0]
    s_time = "#{day} #{selected_date.split(' ')[1]}"
    e_time = "#{day} #{selected_date.split(' ')[3]}"

    # Get dates
    user = User.find(event_params[:user_id])

    event = user.event_dates.build
    event.study_abroad = @study_abroad
    event.hold_date = day
    event.start_time = s_time.to_time(:utc)
    event.end_time = e_time.to_time(:utc)
    event.meeting_place = event_params[:meeting_place]
    event.is_first_time = event_params[:is_first_time] || false
    event.emergency_contact = event_params[:emergency_contact]
    event.event_time = event_params[:event_time]
    event.information = event_params[:information]
    event.is_amazon_card = event_params[:is_amazon_card]

    if event.save!
      session[:event] = event.id

      # Send email to manma.
      CommonMailer.notify_to_manma(params[:tel_time], event).deliver_now

      # Send email to family.
      CommonMailer.notify_to_family_matched(event).deliver_now

      # Send email to candidate.
      CommonMailer.notify_to_candidate(event).deliver_now

      # TODO: resultを消す
      # MEMO: study_abroad_requestが生成される前の@study_abroadが存在する可能性があるためfind_or_initialize_byにしている
      study_abroad_request = @study_abroad.study_abroad_request.find_or_initialize_by(user: user)
      study_abroad_request.update!(user: user, result: true, answer_status: :accepted)

      # Write data to spread sheet
      Google::AuthorizeWithWriteByServiceAccount.do(row(user, event, @study_abroad))

      redirect_to thanks_path
    else
      redirect_to reply_path
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

  # ご回答いただきありがとうございました
  def deny; end

  # すでにマッチングが成立しています
  def sorry; end

  private

  def validate_study_abroad
    # TODO: 404にしたい
    return redirect_to deny_path if @study_abroad.nil? || @study_abroad.is_after_seven_days?

    return redirect_to sorry_path if @study_abroad.is_matched?
  end

  def set_study_abroad_by_hash
    @study_abroad = StudyAbroad.find_by(hashed_key: params[:id])
    validate_study_abroad
  end

  def set_user_by_email
    contact = Contact.find_by(email_pc: params[:email])
    # TODO: 404にしたい
    return redirect_to deny_path if contact.nil? || contact.user.nil?

    if @study_abroad.is_already_replied_by_user?(contact.user.id)
      return redirect_to deny_path
    end

    @user = contact.user
  end

  def set_days
    @days = @study_abroad.request_day
  end

  def set_study_abroad_by_id
    @study_abroad = StudyAbroad.find(event_params[:study_abroad_id])
    validate_study_abroad
  end

  def event_params
    params.require(:event_date).permit(
      :user_id,
      :study_abroad_id,
      :meeting_place,
      :emergency_contact,
      :is_first_time,
      :information,
      :event_time,
      :is_amazon_card
    )
  end

  def row(user, event, study_abroad)
    participant_names = study_abroad.name.split(',')
    participant_emails = study_abroad.email.split(',')
    [
      DateTime.current.strftime('%Y/%m/%d %H:%M:%S'),
      'manma-system',
      user.name, # 家庭代表者氏名
      user.contact.email_pc, # 家族代表者メールアドレス
      'はい', # 受け入れるか？
      participant_names[0],  # 家族留学参加者氏名1
      participant_emails[0], # 家族留学者連絡先email1
      participant_names[1],  # 家族留学参加者氏名2
      participant_emails[1], # 家族留学者連絡先email2
      participant_names[2],  # 家族留学参加者氏名2
      participant_emails[2], # 家族留学者連絡先email2
      '', # TODO: 受け入れ家庭の家族構成（必要なら情報取得）
      event.hold_date.strftime('%Y/%m/%d'), # 実施日時
      event.start_time.strftime('%H:%M:%S'),
      event.end_time.strftime('%H:%M:%S'),
      event.meeting_place,
      event.is_amazon_card ? '有' : '無'
    ]
  end
end
