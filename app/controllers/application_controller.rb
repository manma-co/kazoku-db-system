class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # ログイン後のリダイレクト先の変更
  def after_sign_in_path_for(resource)
    admin_family_index_path
  end

end
