Rails.application.routes.draw do

  namespace :admin do
    get '/' => redirect("admin/family")
    resources :family
  end

  root 'static_pages#index'

  devise_for :admins, :controllers => {
      :omniauth_callbacks => "admin/omniauth_callbacks"
  }

  devise_scope :admin do
    get "admin/sign_out", to: "devise/sessions#destroy"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
