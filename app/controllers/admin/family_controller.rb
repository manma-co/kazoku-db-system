class Admin::FamilyController < Admin::AdminController
  def index
  end

  def show
    user_id = params[:id]
    @family = User.find(user_id)
  end
end
