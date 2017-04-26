class Admin::MailsController < Admin::AdminController

  def new
    user_index = params[:user_id]
    @users = User.where(id: user_index).includes(:profile_family, :location, :contact)
  end

  def confirm

  end
end
