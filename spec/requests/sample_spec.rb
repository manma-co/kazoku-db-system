require 'rails_helper'

RSpec.describe 'Integration Test Sample', type: :request do
  describe 'sample' do
    it '/admin/family リダイレクトさせる' do
      get '/admin/family'
      expect(response).to have_http_status(:redirect)

      # post '/widgets', widget: {name: 'My Widget'}

      # expect(response).to redirect_to(assigns(:widget))
      # follow_redirect!

      # expect(response).to render_template(:show)
      # expect(response.body).to include('Widget was successfully created.')
    end
  end
end
