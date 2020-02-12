require 'rails_helper'

RSpec.describe Admin::MailsController, type: :controller do
  describe 'GET #new' do
    let(:users) { FactoryBot.create_list :user, 10 }

    before do
      login_admin
      get :new, params: { user_id: users.pluck(:id) }
    end

    context 'new' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template :new }
      it { expect(assigns(:users)).to eq users }
      it { expect(assigns(:title)).to eq '【要確認】家族留学受け入れのお願い' }
    end
  end

  describe 'POST #confirm' do
    let(:users) { FactoryBot.create_list :user, 2 }

    before do
      login_admin
      body = <<~EOS
        [manma_user_name]さまのお宅への家族留学を希望されている方がいらっしゃいます。

        ○  参加者プロフィール
        氏名：[manma_template_student_name]
        所属：[manma_template_student_belongs_to]
        最寄り駅：[manma_template_station]
        参加動機：[manma_template_motivation]

        【候補日】
        [manma_template_dates]

        【回答用URL】
        [manma_request_link]
      EOS
      post :confirm, params: {
        user_id: users.pluck(:id),
        title: 'Sample Title',
        email: 'test@example.com',
        emergency: '09012345678',
        student_name: '伊集院空太',
        belongs_to: '慶應義塾大学',
        station: '北千住駅',
        motivation: '環境保護',
        date0: '2018年06月23日 土曜日',
        date1: '2018年06月24日 日曜日',
        date2: '',
        date3: '',
        date4: '',
        start_time0: '10:00',
        start_time1: '11:00',
        finish_time0: '20:00',
        finish_time1: '21:00',
        body: body
      }
    end

    context 'confirm' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template :confirm }
      it { expect(assigns(:body)).to include('2018/06/23 10:00 ~ 20:00') }
      it { expect(assigns(:body)).to include('2018/06/24 11:00 ~ 21:00') }
    end
  end
end
