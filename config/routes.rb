Rails.application.routes.draw do

  root 'static_pages#index'

  namespace :admin do
    get '/' => redirect("admin/family")
    resources :family
    resources :participants, only: [:index, :show]

    resources :locations, :only => [:index, :create]
    get 'locations/search'

    resources :mails, :only => [:new]
    post 'mails/confirm'
    post 'mails/complete'

    get 'mails/histories'
    get 'mails/history/:id', to: 'mails#history', as: 'mails_history'
    get 'spread_sheets/fetch_family'
    get 'spread_sheets/fetch_participant'
    get 'spread_sheets/oauth2callback'
  end

  namespace :api, {format: 'json'} do
    namespace :v1 do
      get "/", :action => 'index'
      namespace :family do
        post "/", :action => 'create'
      end
    end
  end

  get 'request/:id' => 'request#confirm'
  get 'reply/:id' => 'request#reply', as: 'reply'
  post 'reply/create' => 'request#event_create', as: 'event_dates'
  get 'deny' => 'request#deny', as: 'deny'
  get 'thanks' => 'request#thanks', as: 'thanks'
  get 'sorry' => 'request#sorry', as: 'sorry'

  devise_for :admins, :controllers => {
      :omniauth_callbacks => "admin/omniauth_callbacks"
  }

  devise_scope :admin do
    get "admin/sign_out", to: "devise/sessions#destroy"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
