class RequestController < ApplicationController

  layout 'public'

  def confirm
    @log = RequestLog.find_by(hashed_key: params[:id])
    @days = @log.request_day
    @user = Contact.find_by(email_pc: params[:email]).user
  end

end
