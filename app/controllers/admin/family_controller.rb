class Admin::FamilyController < Admin::AdminController
  def index
    @user_list = User.where(is_family: true)
  end

  def show
    user_id   = params[:id]
    @family   = User.find(user_id)
    @mother   = @family.profile_family&.profile_individuals&.find_by(role: 'mother')
    @father   = @family.profile_family&.profile_individuals&.find_by(role: 'father')
    @requests = EmailQueue.where(
        email_type: Settings.email_type.request,
        to_address: @family.contact.email_pc
    )
  end
end
