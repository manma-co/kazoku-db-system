/**
 * Created by shino on 2018/04/25.
 * Updated by go.yokoyama on 2021/08/04
 */
 function submitForm20180425(e){
  var itemResponses = e.response.getItemResponses();
  var message = '';
  var username = '';
  var mail = '';
  for (var i = 0; i < itemResponses.length; i++) {
    var itemResponse = itemResponses[i];
    var question = itemResponse.getItem().getTitle();
    var answer = itemResponse.getResponse();
    if (question == 'お名前'){
      username = answer;
    }
    if (question == 'メールアドレス'){
      mail = answer;
    }
    message += (i + 1).toString() + '. ' + question + ': ' + answer + '\n';
  }
  var address = 'info.manma@gmail.com';
  var title = 'manma（家族留学）登録フォームが送信されました';
  var content = '以下の内容でフォームが送信されました。\n\n' + message;
  GmailApp.sendEmail(address, title, content,{name: 'manma'});

  var title2 = 'manma（家族留学）にご登録いただきありがとうございます';
var content2 = username + '様\n'

+ '\nこの度は、家族留学・受け入れ家庭へご登録ありがとうございます。\n'
+ '家族留学は、子育て家庭に1日訪問もしくはオンラインでの対話を通じて、多様な先輩方との出会いから、自身の生き方・ライフキャリアについて考えるサービスです。\n'

+ '\n土日を中心に、平日の夕方以降も実施をしております。\n'
+ '家族留学の詳細につきましては下記のリンクから、資料をご覧ください。\n'
+ 'https://drive.google.com/file/d/1-6XbWbX_NDu5b6tFEvY4qKGXPdtw4E6g/view?usp=sharing\n'

+ '\n＜受け入れ家庭からよくある質問＞\n'
+ '●受け入れはいつ頃できますか？\n'
+ '参加者の希望条件に応じて、受け入れのご相談をさせていただきます。\n'
+ '登録から受け入れのご相談までお時間が空く場合もございます。ご理解いただけますと幸いです。\n'

+ '\n●どのように受け入れの相談がくるの？\n'
+ '基本、メールにて受け入れのご相談をお送りさせていただきます。\n'
+ '受け入れ可能な場合は、メール内のURLより回答ください。\n'

+ '\n●受け入れに登録費・参加費は発生するか？\n'
+ '受け入れに当たっての登録費、参加費は0円です。\n'

+ '\n●受け入れすると謝礼はもらえるのか？\n'
+ '参加者1名につき、Amazonギフトカード500円を受け入れ翌月にmanmaより送付いたします。\n'
+ 'お仕事の関係などで謝礼を希望されない場合は、受け入れ時にその旨ご回答ください。\n'


+ '\n\n＜facebookコミュニティグループへのお誘い＞\n'
+ '受け入れ家庭の方と家族留学参加者限定のFacebook非公開グループを作りました！！\n'
+ '参加者からの家族留学の感想やmanmaイベントのご案内、限定の募集などを発信しています。\n'
+ '参加希望の際は、下記のURLより申請の方をお願いいたします。\n'
+ 'https://www.facebook.com/groups/289936181853224/\n'

+ '\n\n以下の内容で登録いたしました。\n'
+ message
+ '\n\n何かご不明な点がございましたら下記アドレスまでご連絡ください。\n'
+ 'manma 問い合わせ専用アドレス；info@manma.co\n'

+ '\nmanma家族留学担当\n'
    
  GmailApp.sendEmail(mail, title2, content2, {name: 'manma'});
}