require 'rails_helper'

RSpec.describe Admin::FamilyController, type: :controller do
  describe 'GET #index' do
    let(:users) { FactoryBot.create_list :user, 2 }
    before { login_admin }
    context 'index' do
      before { get :index }
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template :index }
      it { expect(assigns(:users)).to eq users }
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryBot.create(:user) }
    let(:mother) do
      user.profile_family.profile_individuals.find_by(role: 'mother')
    end
    let(:father) do
      user.profile_family.profile_individuals.find_by(role: 'father')
    end
    before { login_admin }
    context 'show' do
      before { get :show, params: { id: user.id } }
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template :show }
      it { expect(assigns(:user)).to eq user }
      it { expect(assigns(:requests)).to eq [] }
      it { expect(assigns(:mother)).to eq mother }
      it { expect(assigns(:father)).to eq father }
    end
  end
end
