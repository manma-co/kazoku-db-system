require 'rails_helper'

RSpec.describe Admin::FamilyController, type: :controller do
  describe 'GET #index' do
    let(:users) { FactoryBot.create_list :user, 2 }

    context 'index' do
      before do
        login_admin
        get :index
      end

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
    before do
      login_admin
      get :show, params: { id: user.id }
    end

    shared_examples_for 'common' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template :show }
      it { expect(assigns(:user)).to eq user }
    end
    context 'when user has all references' do
      let(:user) { FactoryBot.create(:perfect_user) }

      it_behaves_like 'common'
    end

    context 'when user has no contact' do
      let(:user) { FactoryBot.create(:user, :with_profile_family, :with_requests) }

      it_behaves_like 'common'
    end

    context 'when user has no profile_family' do
      let(:user) { FactoryBot.create(:user, :with_contact, :with_requests) }

      it_behaves_like 'common'
      it { expect(assigns(:mother)).to eq nil }
      it { expect(assigns(:father)).to eq nil }
    end

    context 'when user has no requests' do
      let(:user) { FactoryBot.create(:user, :with_contact, :with_profile_family) }

      it_behaves_like 'common'
      it { expect(assigns(:requests)).to eq [] }
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
