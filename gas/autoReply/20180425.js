/**
 * Created by shino on 2018/04/25.
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
    if (question == '氏名'){
      username = answer;
    }
    if (question == 'PCメールアドレス'){
      mail = answer;
    }
    message += (i + 1).toString() + '. ' + question + ': ' + answer + '\n';
  }
  var address = 'info.manma@gmail.com';
  var title = 'manma（家族留学）登録フォームが送信されました';
  var content = '以下の内容でフォームが送信されました。\n\n' + message;
  GmailApp.sendEmail(address, title, content,{name: 'manma'});

  var title2 = 'manma（家族留学）にご登録いただきありがとうございます';
  var content2 = username + '様\n\nこの度は、manma（家族留学）への登録ありがとうございます。\n\n'
    + '以下の内容で登録致しました。\n\n'
    + message
    + '\n'
    + '今後は、manmaが開催するさまざまな体験イベントや家族留学にまつわる最新情報をお届けいたします。\n'
    + '次回のニュースを楽しみにお待ち頂けますと幸いです。\n\n'
    + '下記に家族留学について、簡単にご案内させていただきます。\n\n'
    + 'manmaが運営している家族留学は、大学生を中心とした若者が子育て家庭に\n'
    + '１日、訪問させていただき、多様な先輩方との出会いを通して、自身の生き方について考える企画です。\n\n'
    + '土日を中心に、平日の夕方以降も実施をしております。\n'
    + '家族留学の詳細につきましては\n'
    + '下記のリンクから、資料をご覧ください。\n\n'
    + 'https://drive.google.com/file/d/0Bw1Db0HLPM5JOFgwRjY2M2VnRTQ/view?usp=sharing\n\n'
    + '家族留学受け入れまでの流れについて\n\n'
    + '1．学生へのカウンセリング\n\n'
    + '家族留学への参加申込みがあった学生に対し、事前説明会とカウンセリングを実施します。\n\n'
    + '2．ご家庭とのマッチング\n\n'
    + '学生の希望に基づき、manmaよりご家庭のみなさまに\n'
    + '受け入れのお願いをメールにてお送りします。\n\n'
    + '＊初回受け入れの際には登録いただいた情報にお間違いがないか、\n'
    + '確認のため電話での面談を実施させていただきます。\n\n'
    + '(2)受け入れが可能な場合は、日程調整の完了をもって家族留学の実施決定となります。\n\n'
    + '3．ご家庭と学生をメールにてお繋ぎします。\n\n'
    + '(1)　manmaより、マッチング結果をもとに家族留学実施にあたっての概要（日時・集合場所など）\n'
    + 'について記載したご家庭と学生を繋ぐメールを送信させていただきます。\n\n'
    + '(2)　ご家庭のみなさまにはメールにて自己紹介をお願いしております。\n\n'
    + '(3)　学生には自己紹介ならびに家族留学で聞いてみたいこと３つについて\n'
    + 'メールでの送信をお願いしております。\n\n'
    + '(4） 学生側からの聞いてみたいこと３つに対する回答につきましては、\n'
    + '家族留学中にお答えください。\n\n'
    + '4．家族留学実施\n\n'
    + '当日はご家庭のありのままの姿をお見せしていただけますと幸いです。\n\n'
    + 'また、イベント開催時などには、日程を限定して受け入れてくださる方を\n'
    + '募らせていただくなど、上記の流れとは異なる場合もありますので、ご了承ください。\n\n'
    + '参加者は、WEB上で登録をいただいた後、全員manmaメンバーが面談させていただいています。\n'
    + 'その上で、面談に通った学生さんのみ派遣しておりますので、ご理解いただけましたら幸いです。\n\n'
    + '5．お問い合わせ\n\n'
    + '何かご不明な点がございましたら下記アドレスまでご連絡ください。\n'
    + 'manma 問い合わせ専用アドレス；info@manma.co \n\n'

  GmailApp.sendEmail(mail, title2, content2, {name: 'manma'});
}