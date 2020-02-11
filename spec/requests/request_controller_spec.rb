require 'rails_helper'

describe RequestController, type: :request do
  describe 'GET #reject' do
    before do
      user = FactoryBot.create(:user)
      FactoryBot.create(:contact, user: user, email_pc: "test@test.com")
      request_log = FactoryBot.create(:request_log, hashed_key: "hash")
      FactoryBot.create(:reply_log, request_log: request_log, user: user)
    end

    it '受入拒否をした場合、answer_statusが rejectedとなっていること' do
      get '/reject/hash', params: { email: "test@test.com" }
      expect(response).to redirect_to deny_path
      expect(response.status).to eq 302

      request_log = RequestLog.find_by(hashed_key: "hash")
      expect(request_log.reply_log.first.rejected?).to eq true
    end
  end
  describe 'GET #confirm' do
    before do
      user = FactoryBot.create(:user)
      FactoryBot.create(:contact, user: user, email_pc: "test@test.com")
      FactoryBot.create(:request_log, hashed_key: "hash")
    end

    # TODO: 404にしたい
    it '存在しないhashにアクセスした場合、deny' do
      get '/request/dummy'
      expect(response).to redirect_to deny_path
      expect(response.status).to eq 302
    end

    # TODO: 404にしたい
    it '存在するhashにアクセスしたが、メールアドレスが一致しない場合、deny' do
      get '/request/hash', params: { email: "dummy@dummy.com" }
      expect(response).to redirect_to deny_path
      expect(response.status).to eq 302
    end

    it '存在するhashだが既にマッチング済みの場合、sorry' do
      request_log = RequestLog.find_by(hashed_key: "hash")
      user = User.first
      FactoryBot.create(:reply_log, request_log: request_log, user: user, result: true)
      get '/request/hash', params: { email: "dummy@dummy.com" }

      expect(response).to redirect_to sorry_path
      expect(response.status).to eq 302
    end

    it '存在するhashだが既に回答済みの場合、deny' do
      request_log = RequestLog.find_by(hashed_key: "hash")
      user = User.first
      FactoryBot.create(:reply_log, request_log: request_log, user: user, result: false, answer_status: :rejected)
      get '/request/hash', params: { email: "test@test.com" }

      expect(response).to redirect_to deny_path
      expect(response.status).to eq 302
    end

    it '存在するhashかつ未回答の場合、ページを表示' do
      get '/request/hash', params: { email: "test@test.com" }
      expect(response).to render_template :confirm
      expect(response.status).to eq 200
    end
  end
end
