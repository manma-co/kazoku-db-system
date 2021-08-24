/*
 * 対象フォーム: https://docs.google.com/forms/d/e/1FAIpQLSeCvFUiyzpNZMRFeV1xrBHXLeeI2r4cKZGw7Ac61jQOSKZzlQ/viewform
 * @author shinocchi
 * @updated_at 20210802(go.yokoyama)
 */
function submitForm(e) {
  
  var itemResponses = e.response.getItemResponses();
  // フォームの内容を保持する（manma宛に送信）
  var message = '';
  // 登録者の氏名
  var apply_name = '';
  // 登録者のメールアドレス
  var apply_mail = '';
  // 面談希望日時
  var wish_interview_date = '';
  
  for (var i = 0; i < itemResponses.length; i++) {
    var itemResponse = itemResponses[i];
    var question = itemResponse.getItem().getTitle();
    var answer = itemResponse.getResponse();

    if (question == 'お名前') {
      apply_name = answer;
    }
    if (question == 'メールアドレス') {
      apply_mail = answer;
    }
    // 面談希望日時(オンライン)
    if (question == '面談希望日時' && answer !== '') {
      wish_interview_date = answer;
    }
    message += (i + 1).toString() + '. ' + question + ': ' + answer + '\n';
  }
  
  // manmaメンバー向けメール設定
  var manma_mail = "info.manma@gmail.com";
  var self_body = "以下の内容でフォームが送信されました。\n\n" + message;
  var self_subject = "家族留学参加申し込みあり";

  // 自動送信向けメール設定
  var subject = "【manma】家族留学参加申し込み受付完了のお知らせ";

  // 登録者向け本文
  var body = apply_name + " 様\n"
    + "\n"
    + "この度は、家族留学への参加申し込みをいただきありがとうございます。\n"
    + "\n"
    + "下記日程で、面談を実施させていただきます。\n"
    + "内容をご確認の上、ご参加をお待ちしております。\n"
    + "\n"
    + "・面談日時\n"
    + wish_interview_date + " \n"
    + "\n"
    + "・面談場所\n"
    + "▼オンライン\n"
    + "manmaより別途お送りしますZoomURLにアクセスしてお待ちください。\n"
    + "当日は下記の資料を使いますので、こちらも準備いただくようお願い致します\n"
    + "https://drive.google.com/file/d/19J4ws9nqUTmZGRHSAQWJFC-XboUadj1C/view?usp=sharing\n"
    + "\n"
    + "\n"
    + "・持ち物\n"
    + "身分証明書（初回参加の方のみ）\n"
    + "ご自身のスケジュールが分かるもの（参加希望日確認のため）\n"
    + "\n"
    + "・内容\n"
    + "①家族留学の事前説明（2回目以降の参加の方は説明は省略させていただきます）\n"
    + "②家族留学マッチング\n"
    + "※条件をお伺いし、面談日から2週間～2か月の日程で家族留学を調整致します\n"
    + "\n"
    + "・参加費\n"
    + " 実施日が確定次第お振込頂きます\n"
    + "\n"
    + "※日程変更は原則として受け付けておりません。\n"
    + "面談をキャンセルされる場合は、info@manma.co までご連絡の上\n"
    + "改めて下記リンクより面談をお申込みください。\n"
    + "http://manma.co/student/\n"
    + "\n"
    + "ご不明な点がございましたら\n"
    + "info@manma.coまでお気軽にご連絡ください。\n"
    + "お会いできますことを、楽しみにしております。\n"
    + "manma\n";

  // manmaメンバー向け
  GmailApp.sendEmail(manma_mail, self_subject, self_body, {name: 'manmaシステム'});

  // 登録者向け
  GmailApp.sendEmail(apply_mail, subject, body, {name: 'manma'});
}