// レポートをお願いするscript
// 家族留学実施日に送信されるメールのため
// トリガーは21時-22時が望ましいと思います。
function notifyReport() {
  var MAM_COLUMN = {
    TIMESTAMP: 0,  // A1 記入日
    MANMA_member: 1,  // B1 担当
    FAMILY_NAME: 2,  // C1 お名前（家庭）
    FAMILY_EMAIL: 3,  // D1 ご連絡先（家庭）
    CAN_FAMILY_ABROAD: 4,  // E1 受け入れ可否
    STUDENT_NAME_1: 5,  // F1 参加学生名（1人目）
    STUDENT_EMAIL_1: 6,  // G1 参加学生の連絡先（1人目）
    STUDENT_NAME_2: 7,  // H1 参加学生名（2人目）
    STUDENT_EMAIL_2: 8,  // I1 参加学生の連絡先（2人目）
    STUDENT_NAME_3: 9,  // J1 参加学生名（3人目）
    STUDENT_EMAIL_3: 10,  // K1 参加学生の連絡先（3人目）
    FAMILY_CONSTRUCTION: 11,  // L1 受け入れ家庭の家族構成
    START_DATE: 12,  // M1 実施日時
    START_TIME: 13,  // N1 実施開始時間
    FINISH_TIME: 14,  // O1 実施終了時間
    MTG_PLACE: 15,  // P1 集合場所
    POSSIBLE_DATE: 16,  // Q1 受け入れ可能な日程
    NULL: 17,  // R1
    MAM_CHECK: 18,  // S1 manmaチェック欄 <- 不要になりました
    IS_EMAIL_SENT: 19,  // T1 sent欄 <- 不要になりました
    MAM_REPLY_CHECK: 20,  // U1 manma　返信確認
    IS_CONFIRM_EMAIL_SENT: 21,  // V1 実施sent欄
    CHECK_PAYMENT_1: 22,  // W1 振り込み確認(1人目)
    CHECK_PAYMENT_2: 23,  // X1 振り込み確認(2人目)
    CHECK_PAYMENT_3: 24,  // Y1 振り込み確認(3人目)
    SELF_INTRO_FAM: 25,  // Z1 プロフィール確認(家庭)
    SELF_INTRO_1: 26,  // AA1 プロフィール確認(1人目)
    SELF_INTRO_2: 27,  // AB1 プロフィール確認(2人目)
    SELF_INTRO_3: 28,  // AC1 プロフィール確認(3人目)
    THANK_YOU_MESE1: 29,  // AD1 お礼メール確認欄(1人目)
    THANK_YOU_MESE2: 30,  // AE1 お礼メール確認欄(1人目)
    THANK_YOU_MESE3: 31,  // AF1 お礼メール確認欄(3人目)
    REPORT_1: 32,  // AG1 レポート提出確認(1人目)
    REPORT_2: 33,  // AH1 レポート提出確認(2人目)
    REPORT_3: 34,  // AI1 レポート提出確認(3人目)
  }

  const mSheet = (function () {
    const sheet = SpreadsheetApp.getActive().getSheetByName("フォームの回答");
    const startRow = 2 // First row of data to process
    const lastRow = sheet.getLastRow() - 1
    const lastCol = sheet.getLastColumn()
    const dataRange = sheet.getRange(startRow, 1, lastRow, lastCol)
    return {
      values: function () {
        return dataRange.getValues()
      }
    }
  })()

  const mMail = (function() {
    return {
      subjectForParticipant: function() { return "【manma】家族留学参加のお礼と事後対応のお願い" },
      bodyForParticipant: function(name) {
        if (name === '') { return '' }
        return name + "\n\n"
          + "お世話になっております、manmaです。\n\n"
          + "今回の家族留学はいかがでしたか?\n"
          + "ご参加いただき、大変ありがとうございました。\n\n"
          + "以下、事後の対応事項のご案内です。ご確認・ご対応お願いします。\n"
          + "ぜひ、お写真と共に家族留学の様子や発見をシェアしていただけたら幸いです。\n\n"
          + "１.【必須】 ご家庭へのお礼送付\n\n"
          + "家族留学終了後は、受け入れてくださったご家族に、お礼と学びの報告メールをお送りください。\n"
          + "下記項目を踏まえて、実施日の翌日までに必ず、ご対応お願いします。\n\n"
          + "また、その際には【info.manma@gmail.com】をccにいれてください。\n\n"
          + "◆お礼メールでお伝えいただきたいこと◆\n"
          + "●ご家族のお話の中で印象的だったこと\n"
          + "●家族留学を通して気づいたことや学び\n"
          + "●家族留学時の写真/キャプチャを添付\n\n"
          + "2.【必須】アンケートの記入のお願い\n"
          + "以下のURLよりアンケートの記入をお願いいたします。所要時間は1分ほどです。\n"
          + "https://forms.gle/hY2cdxjDg3sm8Fiq6\n"
          + "※アンケートにて掲載許可をいただいた場合、記載いただいた学び・感想は、\n"
          + "編集し、manmaのSNS及びHPに掲載する可能性がございます。\n"                  
          + "3.【任意】 Facebookグループ「家族留学コミュニティ」への投稿のお願い\n\n"
          + "家族留学コミュニティは、留学生・受け入れ家庭限定のFacebookグループです。\n"
          + "本日の学びや感想を「家族留学コミュニティ」に是非投稿お願いします！\n"
          + "受け入れ家庭の皆様は、留学生の方の気づきや感想を楽しみにされていますので、是非ご協力ください。\n"
          + "まだFacebookグループへ参加されていない方は、下記URLより参加申請ください。\n\n"
          + "https://www.facebook.com/groups/289936181853224\n\n"
          + "皆様のご報告をお待ちしております！\n\n"
          + "◆家族留学にリピート参加してみませんか？◆\n\n"
          + "再度家族留学に参加し、複数の家族のカタチを知ることもおススメです！\n"
          + "前回参加日より3か月以内のリピート参加の場合、参加費が1000円引き♪\n"
          + "参加希望の場合は、以下フォームより改めてお申込みお願いします。\n"
          + "http://manma.co/student/\n\n"
          + "何卒よろしくお願いいたします。\n"
          + "manma\n"
      },
      subjectForFamily: function() { return "【manma】家族留学受け入れのお礼" },
      bodyForFamily: function(name) {
        return name + "様\n\n"
          + "お世話になっております、manma 家族留学担当です。\n"
          + "今回は留学生を受け入れてくださり、本当にありがとうございました！\n\n"
          + "家族留学はいかがでしたでしょうか。\n"
          + "ご家庭のみなさまにとっても、楽しい時間となっておりましたら嬉しく思います。\n\n"
          + "今回の家族留学を通じて、参加者にとって将来につながる変化や気づきがあったことと思います。\n"
          + "留学生にも、お礼メールを送付していただくようお願いはしておりますが\n"
          + "今後も家族留学参加後にメールやSNS等で連絡のやり取りをしていただき\n"
          + "つながりを深めていただけたら嬉しく思います。\n\n"                        
          + "また、受け入れ家庭の皆さまには、家族留学後に簡単なアンケートへのご協力をお願いしております。\n"
          + "今後の運営の参考に、是非ご回答いただけますと幸いです。\n"
          + "▷▷▷　https://forms.gle/hY2cdxjDg3sm8Fiq6\n\n"
          + "manmaでは参加者の感想をお写真とともにmanmaSNSにてご紹介しております。\n"
          + "写真掲載可否に変更ある際は、アンケートにて併せてお知らせください。\n\n"
          + "また、manmaでは受け入れ家庭・留学生限定のグループ「家族留学コミュニティ」を運営しています。\n"
          + "家族留学コミュニティでは、manmaから限定のお知らせやイベント案内、留学生の感想等をご覧いただけます。\n"
          + "是非、下記URLより参加申請をお願いします。\n"
          + "https://www.facebook.com/groups/289936181853224\n\n"  
          + "この度は、貴重な機会をご提供くださり、本当にありがとうございました！\n\n"
          + "引き続き、家族留学およびmanmaをよろしくお願いいたします。\n\n"
          + "manma"
      },
      send: function(email, subject, body) {
        if (email === '' || body === ''){ return }
        // Logger.log(email + "に送信"); Logger.log(subject); Logger.log(body)
        GmailApp.sendEmail(email, subject, body, {name: 'manma'})
      }
    }
  })()

  const mDate = (function () {
    return {
      today: function () {
        return Utilities.formatDate(new Date(), 'JST', 'yyyy/MM/dd')
      },
      todayOfDateType: function () {
        // 今日の日付のDate型を取得する
        return new Date(Date.parse(Utilities.formatDate(new Date(), 'JST', 'yyyy/MM/dd')))
      },
      before: function (targetDate, beforeDays) {
        // targetDateの日付からbeforeDays日前を取得する
        return Utilities.formatDate((new Date((targetDate.getTime()) - (60 * 60 * 24 * 1000) * beforeDays)), 'JST', 'yyyy/MM/dd')
      },
      after: function (targetDate, afterDays, isFormatted) {
        if (isFormatted !== false) {
          return Utilities.formatDate((new Date((targetDate.getTime()) + (60 * 60 * 24 * 1000) * afterDays)), 'JST', 'yyyy/MM/dd')
        } else {
          return new Date((targetDate.getTime()) + (60 * 60 * 24 * 1000) * afterDays)
        }
      },
    }
  })()

  const data = mSheet.values()
  for (var i = 0; i < data.length; ++i) {
    var row = data[i];

    // 返信確認ステータスが空 = 家族留学が実施されていない ので送信しない
    var mail_status = row[MAM_COLUMN.IS_CONFIRM_EMAIL_SENT]
    if (mail_status === "") {
      continue
    }

    var student_name = row[MAM_COLUMN.STUDENT_NAME_1] + "さま";
    var student_mail = row[MAM_COLUMN.STUDENT_EMAIL_1];
    if (row[MAM_COLUMN.STUDENT_NAME_2] != "") {
      student_name = student_name + "," + row[MAM_COLUMN.STUDENT_NAME_2] + "さま";
      student_mail = student_mail + "," + row[MAM_COLUMN.STUDENT_EMAIL_2];
    }
    if (row[MAM_COLUMN.STUDENT_NAME_3] != "") {
      student_name = student_name + "," + row[MAM_COLUMN.STUDENT_NAME_3] + "さま";
      student_mail = student_mail + "," + row[MAM_COLUMN.STUDENT_EMAIL_3];
    }

    var family_name = row[MAM_COLUMN.FAMILY_NAME];
    var family_mail = row[MAM_COLUMN.FAMILY_EMAIL];
    var family_abroad_date = new Date(row[MAM_COLUMN.START_DATE]);
    var f_family_abroad_date = Utilities.formatDate(family_abroad_date, 'JST', 'yyyy/MM/dd')

    // 家族留学実施日なら送信
    if (f_family_abroad_date == mDate.today()) {
      mMail.send(student_mail, mMail.subjectForParticipant(), mMail.bodyForParticipant(student_name))
      mMail.send(family_mail, mMail.subjectForFamily(), mMail.bodyForFamily(family_name))
    }
  }
}