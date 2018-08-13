class Admin::AdminController < ApplicationController
  layout 'admin/admin'
  before_action :authenticate_admin!

  include Admin::AdminHelper

  def index
    @admins = Admin.all
  end

  def new() end

  def create
    admin = Admin.new(admin_params)
    if admin.save
      redirect_to admin_admin_index_path, notice: '登録成功'
    else
      redirect_to admin_admin_index_path, notice: '登録失敗'
    end
  end

  def destroy
    admin = Admin.find(params[:id])
    if admin.destroy
      redirect_to admin_admin_index_path, notice: '削除成功'
    else
      redirect_to admin_admin_index_path, notice: '削除失敗'
    end
  end

  private

  def admin_params
    params.permit(:email)
  end

end
