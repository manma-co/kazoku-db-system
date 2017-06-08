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
    store_user_info
    store_date_n_time construct_dates
  end

  def complete
    user_params
    log, hash = save_request_log
    save_request_day log
    @body = params[:body]
    @title = params[:title]
    CommonMailer.request_email_to_family(@title, @body, @users, hash, root_url(only_path: false)).deliver_now
  end

  def histories
    @sent_mails = EmailQueue.all
  end

  def history
    @sent_mail = EmailQueue.find(params[:id])
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

  # 希望日程、開始日時、終了日時をパースして文字列化 -> 配列
  def construct_dates
    # 改行文字列
    br = <<-EOS

    EOS

    # 希望日程、開始日時、終了日時をパースして文字列化 -> 配列
    ((0..4).to_a.map { |i|
      date_key = "date#{i}_submit".to_sym
      start_time_key = "start_time#{i}".to_sym
      finish_time_key = "finish_time#{i}".to_sym

      date = params[date_key]
      next if date == ''
      start_time = params[start_time_key]
      finish_time = params[finish_time_key]

      "#{date} #{start_time} ~ #{finish_time}"
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
 
こちらのURLからご回答ください。
[manma_request_link]

 
＊  注意事項＊
・  受け入れてくださる方はこちらのメールに返信という形でお願いいたします。その際にお手数ですが＜受け入れてくださる日程・時間＞を忘れずにご記入ください。
・  こちらのシステムは返信が最も早かったご家庭に家族留学させていただきます。ご返信いただいても前に他のご家庭から返信が来ている場合はキャンセルとなります。ご了承ください。
 

何かご不明な点がございましたら、kubo@manma(担当：久保)までご連絡ください。

 
manma
EOS
  end

end