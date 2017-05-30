class RequestController < ApplicationController

  layout 'public'

  def confirm
    @log = RequestLog.find_by(hashed_key: params[:id])
    @days = @log.request_day unless @log.nil?
    contact = Contact.find_by(email_pc: params[:email])
    @user = contact.user if contact
    if @user
      reply = ReplyLog.find_by(request_log_id: @log.id, user_id: @user.id)
      redirect_to deny_path if reply
    end
    redirect_to deny_path if @user.nil?
  end

  def reply
    @log = RequestLog.find_by(hashed_key: params[:id])
    @days = @log.request_day
    @user = Contact.find_by(email_pc: params[:email]).user
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
      # TODO: check uniqueness
      reply.save!
      redirect_to :deny
    end
  end

end
