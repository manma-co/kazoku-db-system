require 'rails_helper'

RSpec.describe Admin::FamilyController, type: :controller do
  describe 'GET #index' do
    let(:users) { FactoryBot.create_list :user, 2 }
    before { login_admin }
    context 'index' do
      before { get :index }
      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns :users).to eq users }
    end
  end
end
