class CommonMailer < ApplicationMailer
  # Development の時はyoshihito.meからとりあえず送る設定。
  if Rails.env.development?
    default from: 'manma <localhost:3000>'
  else
    default from: 'manma <info@manma.co>'
  end

  # マッチング成立時に使う。
  def matched_email(contact)
    @contact = contact
    @user = @contact.user
    mail(to: @contact.email_pc, subject: '【重要 / 家族留学】マッチングしました')
  end

  # 家庭向けに家族留学希望者がいることを知らせるメール。
  def request_email_to_family(title, body, user, hash, root_url, study_abroad)
    # Disable memory pointer with dup method.
    mail_body = body.dup

    mail = user.contact.email_pc

    # Use user to show user name for each email.
    @user = user

    # Create and insert hash link with user email
    link = root_url + 'request/' + hash + '?email=' + mail
    mail_body.sub!(/\[manma_request_link\]/, link)

    # Replace user name.
    mail_body.sub!(/\[manma_user_name\]/, @user.name)

    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: mail,
      bcc_address: 'info@manma.co',
      subject: title,
      body_text: mail_body,
      study_abroad: study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.request
    )
    @body = mail_body
    mail(to: mail, subject: title)
    queue = EmailQueue.where(
      to_address: mail,
      study_abroad: study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.request
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end

  # マッチング成立時にmanmaに送るメール。
  # 電話の日付が入る場合もあり
  def notify_to_manma(tel_time, event)
    @tel_time = tel_time
    @event = event unless event.nil?
    @user = User.find(event.user_id)

    title = ''
    title += '電話対応あり / ' if @event.is_first_time
    title += '【重要】マッチング成立のお知らせ'
    title || title += @event.start_time.strftime('%Y年%m月%d日')

    body = MailerBody.notify_to_manma(@tel_time, @event, @user)
    study_abroad = StudyAbroad.find(@event.study_abroad_id)

    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: 'info@manma.co',
      bcc_address: 'info@manma.co',
      subject: title,
      body_text: body,
      study_abroad: study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.manma
    )
    # Send a mail
    mail(to: 'info@manma.co', subject: title)
    # Update email queue status
    queue = EmailQueue.where(
      to_address: 'info@manma.co',
      study_abroad: study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.manma
    ).order('id desc').limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end

  # マッチング成立時に家庭に向けて送る
  def notify_to_family_matched(event)
    @user = User.find(event.user_id)
    study_abroad = StudyAbroad.find(event.study_abroad_id)
    mail = @user.contact.email_pc
    title = '【manma】家族留学を受け入れてくださりありがとうございます'
    @student = study_abroad
    @event = EventDate.find_by(study_abroad_id: study_abroad.id)

    body = MailerBody.notify_to_family_matched(@user, @student, @event)

    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: mail,
      bcc_address: 'info@manma.co',
      subject: title,
      body_text: body,
      study_abroad: study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.family_matched
    )
    # Send a mail
    mail(to: mail, subject: title)
    # Update email queue status
    queue = EmailQueue.where(
      to_address: mail,
      study_abroad: study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.family_matched
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end

  # マッチング成立時に参加者に向けて送る
  def notify_to_candidate(event)
    @event = event
    @study_abroad = StudyAbroad.find(event.study_abroad_id)
    @user = User.find(event.user_id)
    title = '【manma】家族留学のマッチングが成立いたしました'

    body = MailerBody.notify_to_candidate(@event, @study_abroad, @user)

    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: @study_abroad.email,
      bcc_address: 'info@manma.co',
      subject: title,
      body_text: body,
      study_abroad: @study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.candidate
    )
    mail(to: @study_abroad.email, subject: title)
    # Update email queue status
    queue = EmailQueue.where(
      to_address: @study_abroad.email,
      study_abroad: @study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.candidate
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end

  # マッチング開始時に参加者に向けて送る
  def matching_start(study_abroad)
    body = MailerBody.matching_start
    title = '【manma】家族留学の打診を開始いたしました'
    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: study_abroad.email,
      bcc_address: 'info@manma.co',
      subject: title,
      body_text: body,
      study_abroad: study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.matching_start
    )

    # Send a mail
    mail(to: study_abroad.email, subject: title)
    # Update email queue status
    queue = EmailQueue.where(
      to_address: study_abroad.email,
      study_abroad: study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.matching_start
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end

  # マッチングを断った場合に家庭に送る
  def deny(study_abroad, user)
    @user = user
    title = '【manma】家族留学受け入れ可否のご回答をありがとうございました'

    body = MailerBody.deny(@user)
    mail = user.contact.email_pc

    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: mail,
      bcc_address: 'info@manma.co',
      subject: title,
      body_text: body,
      study_abroad: study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.deny
    )
    mail(to: mail, subject: title)
    queue = EmailQueue.where(
      to_address: mail,
      study_abroad: study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.deny
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end

  # 参加者向けに再打診候補日程をもらうメール
  def readjustment_to_candidate(study_abroad)
    @study_abroad = study_abroad
    title = '【要返信】家族留学の再打診に関しまして'

    body = MailerBody.readjustment_to_candidate(@study_abroad)

    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: study_abroad.email,
      bcc_address: 'info@manma.co',
      subject: title,
      body_text: body,
      study_abroad: study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.readjustment
    )
    mail(to: study_abroad.email, subject: title)
    queue = EmailQueue.where(
      to_address: study_abroad.email,
      study_abroad: study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.readjustment
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end

  # 再打診メールを info@manma.co にもお知らせする。
  def readjustment_to_manma(study_abroad)
    @study_abroad = study_abroad
    title = '自動送信 →【要返信】家族留学の再打診に関しまして'

    body = MailerBody.readjustment_to_manma(@study_abroad)

    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: 'info@manma.co',
      subject: title,
      body_text: body,
      study_abroad: study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.readjustment_to_manma
    )
    mail(to: 'info@manma.co', subject: title)
    queue = EmailQueue.where(
      to_address: 'info@manma.co',
      study_abroad: study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.readjustment_to_manma
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end

  include ApplicationHelper

  # リマインダーメールの送信に使う
  def reminder_three_days(user, study_abroad)
    root = default_host_url
    @user = user
    @study_abroad = study_abroad
    @days = RequestDay.where(study_abroad: study_abroad)
    @url = root + 'request/' + @study_abroad.hashed_key + '?email=' + user.contact.email_pc
    title = '【リマインド】家族留学受け入れのお願い'

    body = MailerBody.reminder_three_days(@user, @study_abroad, @days, @url)
    mail = user.contact.email_pc

    # Insert to DB
    EmailQueue.create!(
      sender_address: 'info@manma.co',
      to_address: mail,
      bcc_address: 'info@manma.co',
      subject: title,
      body_text: body,
      study_abroad: study_abroad,
      retry_count: 0,
      sent_status: false,
      email_type: Settings.email_type.three_days
    )
    mail(to: mail, subject: title)
    queue = EmailQueue.where(
      to_address: mail,
      study_abroad: study_abroad,
      subject: title,
      sent_status: false,
      email_type: Settings.email_type.three_days
    ).limit(1)
    queue.update(sent_status: true, time_delivered: Time.zone.now)
  end
end
