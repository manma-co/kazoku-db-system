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

  def new
    # TODO: user.timestamp発行機能
  end

  def edit
    user_id = params[:id]
    @family = User.find(user_id)
    @mother = @family.profile_family&.profile_individuals&.find_by(role: 'mother')
    @father = @family.profile_family&.profile_individuals&.find_by(role: 'father')
  end

  def update
    user_id = params[:id]
    @family = User.find(user_id)
    if @family.update(family_params)
      redirect_to edit_admin_family_path(user_id), notice: '更新成功'
    else
      redirect_to edit_admin_family_path(user_id), alert: '更新失敗'
    end
  end

  private

  def family_params
    params.permit(:name, :kana)
  end

end
