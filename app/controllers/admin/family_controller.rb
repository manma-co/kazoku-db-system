class Admin::FamilyController < Admin::AdminController
  def index
    @user_list = User.where(is_family: true)
  end

  def show
    user_id = params[:id]
    @family = User.find(user_id)
  end
end
