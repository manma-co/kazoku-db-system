class Admin::MailsController < Admin::AdminController

  def new
    init_mail
    user_params
  end

  def confirm
    user_params
    construct_dates
    @title = params[:title]
    construct_body
  end

  def complete
    # TODO: メール送信機能
    user_params
    @body = params[:body]
    @title = params[:title]
    CommonMailer.request_email_to_family(@title, @body, @users).deliver_now
    CommonMailer.notify_to_manma(@title, @body).deliver_now
  end

  private

  def user_params
    user_index = params[:user_id]
    @users = User.where(id: user_index).includes(:profile_family, :location, :contact)
  end

  # テンプレートから本文を組み立てる
  def construct_body
    no_input_text = '入力されていません'
    student_name = params[:student_name].blank? ? no_input_text : params[:student_name]
    belongs_to = params[:belongs_to].blank? ? no_input_text : params[:belongs_to]
    station = params[:station].blank? ? no_input_text : params[:station]
    motivation = params[:motivation].blank? ? no_input_text : params[:motivation]

    @body = params[:body]
    @body.sub!(/\[manma_template_student_name\]/, student_name)
    @body.sub!(/\[manma_template_student_belongs_to\]/, belongs_to)
    @body.sub!(/\[manma_template_station\]/, station)
    @body.sub!(/\[manma_template_motivation\]/, motivation)
    @body.sub!(/\[manma_template_dates\]/, construct_dates)
  end

  def construct_dates
    br = <<-EOS

    EOS
    (params[:date].map { |key, date|
      if date != ''
        date = DateTime.strptime(date, '%Y-%m-%dT%H:%M')
        date.strftime('%Y年%m月%d日 %H時%M分')
      end
    }).join(br)
  end

  # 本文のテンプレートで初期化する
  def init_mail
    @title =  '【要返信】家族留学受け入れのお願い'
    @body = <<-EOS
 
受け入れ家庭のみなさまへ
 
こんにちは、manmaです。
いつも大変お世話になっております。
 
家族留学を受け入れていただきたく、ご連絡いたしました。
 
登録していただいている学生の方で、ぜひ家族留学してみたいという方がいらっしゃいます。

下記打診内容をご確認いただき、受け入れ可能な日程がございましたら、＜受け入れ日程・時間＞を明記の上、こちらのメールにご返信ください。
 
○  参加者プロフィール
氏名：[manma_template_student_name]
所属：[manma_template_student_belongs_to]
最寄り駅：[manma_template_station]
参加動機：[manma_template_motivation]
 
【候補日】
[manma_template_dates]
 
 ＝＝＝＝＝＝返信用フォーマット＝＝＝＝＝＝＝＝
●受け入れ可能 or 不可
●受け入れ可能日程：
●受け入れ可能時間：
※  家族留学の時間は５時間以上でご検討ください。
●備考：
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
連絡先： kubo@manma.co（担当：久保）


 
＊  注意事項＊
・  受け入れてくださる方はこちらのメールに返信という形でお願いいたします。その際にお手数ですが＜受け入れてくださる日程・時間＞を忘れずにご記入ください。
・  こちらのシステムは返信が最も早かったご家庭に家族留学させていただきます。ご返信いただいても前に他のご家庭から返信が来ている場合はキャンセルとなります。ご了承ください。
 

何かご不明な点がございましたら、kubo@manma(担当：久保)までご連絡ください。

 
manma
EOS
  end

end
