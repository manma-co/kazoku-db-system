require 'rails_helper'

describe RequestController, type: :request do
  describe 'POST #reject' do
    before do
      user = FactoryBot.create(:user)
      FactoryBot.create(:contact, user: user, email_pc: 'test@test.com')
      study_abroad = FactoryBot.create(:study_abroad, hashed_key: 'hash')
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user)
    end

    it '受入拒否をした場合、answer_statusが rejectedとなっていること' do
      post '/reject/hash', params: { email: 'test@test.com', reason: '〇〇✖︎✖︎のため' }
      expect(response).to redirect_to deny_path
      expect(response.status).to eq 302

      study_abroad = StudyAbroad.find_by(hashed_key: 'hash')
      expect(study_abroad.study_abroad_request.first.rejected?).to eq true
    end
  end

  describe 'GET #confirm' do
    before do
      user = FactoryBot.create(:user)
      FactoryBot.create(:contact, user: user, email_pc: 'test@test.com')
      FactoryBot.create(:study_abroad, hashed_key: 'hash')
    end

    # TODO: 404にしたい
    it '存在しないhashにアクセスした場合、deny' do
      get '/request/dummy'
      expect(response).to redirect_to deny_path
      expect(response.status).to eq 302
    end

    # TODO: 404にしたい
    it '存在するhashにアクセスしたが、メールアドレスが一致しない場合、deny' do
      get '/request/hash', params: { email: 'dummy@dummy.com' }
      expect(response).to redirect_to deny_path
      expect(response.status).to eq 302
    end

    it '存在するhashだが既にマッチング済みの場合、sorry' do
      study_abroad = StudyAbroad.find_by(hashed_key: 'hash')
      user = User.first
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user, result: true)
      get '/request/hash', params: { email: 'dummy@dummy.com' }

      expect(response).to redirect_to sorry_path
      expect(response.status).to eq 302
    end

    it '存在するhashだが既に回答済みの場合、deny' do
      study_abroad = StudyAbroad.find_by(hashed_key: 'hash')
      user = User.first
      FactoryBot.create(:study_abroad_request, study_abroad: study_abroad, user: user, result: false, answer_status: :rejected)
      get '/request/hash', params: { email: 'test@test.com' }

      expect(response).to redirect_to deny_path
      expect(response.status).to eq 302
    end

    it '存在するhashかつ未回答の場合、ページを表示' do
      get '/request/hash', params: { email: 'test@test.com' }
      expect(response).to render_template :confirm
      expect(response.status).to eq 200
    end
  end
end
