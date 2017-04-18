class Admin::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    info = request.env["omniauth.auth"].info
    @admin = Admin.find_by(:email => info["email"])

    session[:user_info] = info

    if @admin&.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @admin, :event => :authentication
    else
      flash[:notice] = I18n.t "devise.omniauth_callbacks.failure", :kind => "Google", :reason => 'this email addres is not registerd'
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end
end
