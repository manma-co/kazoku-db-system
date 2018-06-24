require 'rails_helper'

RSpec.describe Admin::FamilyController, type: :controller do
  describe 'GET #index' do
    let(:users) { FactoryBot.create_list :user, 2 }
    context 'index' do
      before {
        login_admin
        get :index
      }
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template :index }
      it { expect(assigns(:users)).to eq users }
    end
    context 'index when admin is not logged in' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template nil }
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

  describe 'DELETE #destroy' do
    let(:user) { FactoryBot.create(:user) }
    before { login_admin }
    context 'destroy' do
      before { delete :destroy, params: { id: user.id } }
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to admin_family_index_path }
    end
  end
end
