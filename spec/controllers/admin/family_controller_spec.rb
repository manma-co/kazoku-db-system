require 'rails_helper'

RSpec.describe Admin::FamilyController, type: :controller do
  describe 'GET #index' do
    before { login_admin }
    context 'index' do
      before { get :index }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
