class Admin::FamilyController < Admin::AdminController
  def index
  end

  def show
    p user_id = params[:id] # user no id

    p user = User.find(user_id)

  end
end
