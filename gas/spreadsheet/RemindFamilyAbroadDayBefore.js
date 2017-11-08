/*
 * 家族留学前日にリマインドメールを送信する
 * composed by shinocchi 20171109
 */
function remindFamilyAbroadDayBefore() {
  // フォーム回答の場合を実行
  const MAM_COLUMN = {
    TIMESTAMP:              0,  // A1 記入日
    MANMA_member:           1,  // B1 担当
    FAMILY_NAME:            2,  // C1 お名前（家庭）
    FAMILY_EMAIL:           3,  // D1 ご連絡先（家庭）
    CAN_FAMILY_ABROAD:      4,  // E1 受け入れ可否
    STUDENT_NAME_1:         5,  // F1 参加学生名（1人目）
    STUDENT_EMAIL_1:        6,  // G1 参加学生の連絡先（1人目）
    STUDENT_NAME_2:         7,  // H1 参加学生名（2人目）
    STUDENT_EMAIL_2:        8,  // I1 参加学生の連絡先（2人目）
    STUDENT_NAME_3:         9,  // J1 参加学生名（3人目）
    STUDENT_EMAIL_3:       10,  // K1 参加学生の連絡先（3人目）
    FAMILY_CONSTRUCTION:   11,  // L1 受け入れ家庭の家族構成
    START_DATE:            12,  // M1 実施日時
    START_TIME:            13,  // N1 実施開始時間
    FINISH_TIME:           14,  // O1 実施終了時間
    MTG_PLACE:             15,  // P1 集合場所
    POSSIBLE_DATE:         16,  // Q1 受け入れ可能な日程
    NULL:                  17,  // R1
    MAM_CHECK:             18,  // S1 manmaチェック欄
    IS_EMAIL_SENT:         19,  // T1 sent欄
    MAM_REPLY_CHECK:       20,  // U1 manma　返信確認
    IS_CONFIRM_EMAIL_SENT: 21,  // V1 実施sent欄
    CHECK_PAYMENT_1:       22,  // W1 振り込み確認(1人目)
    CHECK_PAYMENT_2:       23,  // X1 振り込み確認(2人目)
    CHECK_PAYMENT_3:       24,  // Y1 振り込み確認(3人目)
    SELF_INTRO_FAM:        25,  // Z1 プロフィール確認(家庭)
    SELF_INTRO_1:          26,  // AA1 プロフィール確認(1人目)
    SELF_INTRO_2:          27,  // AB1 プロフィール確認(2人目)
    SELF_INTRO_3:          28,  // AC1 プロフィール確認(3人目)
    THANK_YOU_MESE1:       29,  // AD1 お礼メール確認欄(1人目)
    THANK_YOU_MESE2:       30,  // AE1 お礼メール確認欄(1人目)
    THANK_YOU_MESE3:       31,  // AF1 お礼メール確認欄(3人目)
    REPORT_1:              32,  // AG1 レポート提出確認(1人目)
    REPORT_2:              33,  // AH1 レポート提出確認(2人目)
    REPORT_3:              34,  // AI1 レポート提出確認(3人目)
  }

  const sheetName = 'フォームの回答'
  // シート情報取得
  const sheet = SpreadsheetApp.getActive().getSheetByName(sheetName)

  const startRow = 2
  const lastRow = sheet.getLastRow() - 1 ;
  const lastCol = sheet.getLastColumn();

  // 今日の日付をフォーマットして取得
  const today = new Date();
  const year = today.getFullYear();
  const month = today.getMonth() + 1;
  const day = today.getDate();

  const current_time_ms = new Date(year, month-1, day).getTime();              // 今日の日付のmsを取得
  const in_one_day = new Date(current_time_ms + (60 * 60 * 24 * 1000) * 1);   // 今日から1日後

  const dataRange = sheet.getRange(startRow, 1, lastRow, lastCol);
  const data = dataRange.getValues();

  for (var i = 0; i < data.length; ++i) {
    var row = data[i];

    var status = row[MAM_COLUMN.CAN_FAMILY_ABROAD];
    if (status == "いいえ") {
      continue;
    }

    // 複数人対応するために student_name に　"さま"を付与する
    var student_name = row[MAM_COLUMN.STUDENT_NAME_1]+"さま";
    var student_mail = row[MAM_COLUMN.STUDENT_EMAIL_1];
    if (row[MAM_COLUMN.STUDENT_NAME_2] != ""){
      student_name = student_name + "," + row[MAM_COLUMN.STUDENT_NAME_2]+"さま";
      student_mail = student_mail + "," + row[MAM_COLUMN.STUDENT_EMAIL_2];
    }
    if (row[MAM_COLUMN.STUDENT_NAME_3] != ""){
      student_name = student_name +"," + row[MAM_COLUMN.STUDENT_NAME_3]+"さま";
      student_mail = student_mail +"," + row[MAM_COLUMN.STUDENT_EMAIL_3];
    }

    var family_name = row[MAM_COLUMN.FAMILY_NAME];                         // E - 受け入れ家庭のお名前
    var construction = row[MAM_COLUMN.FAMILY_CONSTRUCTION];                // F - 受け入れ家庭の家族構成
    var family_mail = row[MAM_COLUMN.FAMILY_EMAIL];                        // G - 受け入れ家庭のご連絡先
    var family_abroad_date = new Date(row[MAM_COLUMN.START_DATE]);         // H - 実施日時
    var family_abroad_datetime = new Date(row[MAM_COLUMN.START_TIME]);     // I - 実施開始時間
    var meeting_location = row[MAM_COLUMN.MTG_PLACE];                      // J - 集合場所
    var family_abroad_finish_time = new Date(row[MAM_COLUMN.FINISH_TIME]); // N - 実施終了時間

    var family_abroad_time = family_abroad_date.getTime();  // 家族留学実施日ms秒
    var f_family_abroad_date = Utilities.formatDate(family_abroad_date, 'JST', 'yyyy/MM/dd');
    var f_family_abroad_datetime = Utilities.formatDate(family_abroad_datetime, 'JST', 'HH:mm');
    var f_family_abroad_finish_time = Utilities.formatDate(family_abroad_finish_time, 'JST', 'HH:mm');

    // 日付算: new Date(0) = 1970/01/01
    var diff_abroad_current = family_abroad_time - current_time_ms;   // 家族留学実施日のms秒 - 今日の日付のms秒
    var diff_in_ten_days_abroad =  in_one_day - family_abroad_time;   // 今日から1日後のms秒 - 家族留学実施の日付のms秒

    // メールは送信済みか？(V1: 実施sent欄)
    var check_mail_status = row[MAM_COLUMN.IS_CONFIRM_EMAIL_SENT];
    if (check_mail_status != "") {
      // Logger.log("メールが送信されている記録があるため通知しない");
      continue;
    }

    if (diff_in_ten_days_abroad < 0) {
      // Logger.log("家族留学実施より10日よりも前なので通知しない");
      continue;
    }
    if (diff_abroad_current <= 0) {
      // Logger.log("家族留学が終了しているため通知しない");
      continue;
    }
    if (family_mail === "") {
      // Logger.log("家庭用メールが空なので通知しない")
      continue
    }
    if (student_mail === "") {
      // Logger.log("学生メールが空なので通知しない")
      continue
    }

    var mail = family_mail + "," + student_mail + "," + ""
    var subject = "【manma】家族留学当日のお知らせ";
    var message = "受け入れ家庭\n"
      + family_name + "さま\n\n"
      + "留学生\n"
      + student_name + "\n\n"
      + "お世話になっております。"
      + "家族留学実施日が近づいてまいりましたので、\n\n"
      + "manmaより、当日についてご連絡いたします。\n\n"
      + "◆家族留学実施概要◆\n"
      + "実施日：" + f_family_abroad_date + "\n"
      + "集合時間："+ f_family_abroad_datetime + "\n"
      + "集合場所：" + meeting_location + "\n"
      + "終了予定時間：" + f_family_abroad_finish_time + "\n"
      + "参加大学生：" + student_name + "\n"
      // TODO: manmaシステムから家族構成情報を送信していない。確認事項。
      // + "ご家族構成：" + construction + "\n"
      + "緊急連絡先：\n"
      + "info.manma@gmail.com（manmaメール）\n\n"
      + "またお手数ですが、下記の項目について\n"
      + "こちらのメールに【全員に返信】していただく形で\n"
      + "みなさま簡単に自己紹介と、緊急連絡先をお伝えください。（＊③、④は参加者のみ\n\n"
      + "①自己紹介 \n"
      + "→現在の所属、将来に対するイメージ（職種やキャリア、結婚、働き方など）\n"
      + "②緊急連絡先（携帯番号）\n"
      + "③家族留学の目標\n"
      + "（例：子供への接し方を学ぶこと、自分の将来の生活のヒントを得ること、◯◯さまご一家と仲良くなること など）\n"
      + "④聞いてみたいこと3つ\n"
      + "ご自身のキャリアプランへの不安をもとにお考えください\n"
      + "（例：結婚・出産のタイミング、両立のコツ、育児で大切にしていること）\n"
      + "体験してみたいことがございましたら、ぜひ積極的にお伝えください！\n"
      + "また、ご家庭のみなさまは、参加者からの質問にメールにて事前にお答えいただけますと幸いです。\n"
      + "その際に『受入れの際に学生に留意してほしい点/子育てで大事にされており事前に知ってほしいこと』等ございましたらご記載ください。\n"
      + "例：食物アレルギーがあるため特定の食材は食べさせないようにしてほしい/スマートフォン等に触れさせないようにしたいなど\n\n"
      + "＊その他注意事項＊\n"
      + "・食事代を１日５００円（昼・夜２回でも一律の金額になります）ご家庭にお支払いください。\n"
      + "・当日合流された場合は、こちらのメールに返信する形でご一報くださいませ。\n"
      + "特に解散時には、学生のみなさんより当日の写真を添付してmanmaにご連絡していただきますようお願いいたします。\n"
      + "manmaにメールを送信したことを確認したのち、帰宅されてください。\n"
      + "・学生のみなさまには実施日翌日までに、ご家庭へのお礼・感想メールをお送りいただくようにお願いしております。\n"
      + "下記の項目を含め、できるだけ詳細にご記入ください。\n\n"
      + "---------------------------記入事項-----------------------------\n\n"
      + "〈家族留学を通してきづいたことや学び（３つほど）〉\n"
      + "〈家族留学を通じて変わったこと、変わらなかったことなど感想〉\n"
      + "------------------------------------------------------------------------\n\n"
      + "・受け入れ家庭の皆さまには、家族留学後に簡単なアンケートへのご協力をお願いしております。\n"
      + "実施日当日の夜に再度メールでご連絡いたしますので、翌日までにご回答いただけますと幸いです。\n"
      + "▷▷▷ https://docs.google.com/forms/d/1ifAZFTc-xn1cCBB-GmZMMJi6yBcBmypl06RBFBZ1U6A/edit\n\n"
      + "・家族留学のやりとりには、必ず【info.manma@gmail.com】を\n"
      + "ccに入れていただきますようお願いいたします。\n\n"
      + "当日の集合場所や時間、スケジュールに関するご相談なども、\n"
      + "ぜひこちらのメールをご活用ください。\n\n"
      + "当日、よりキャリアや子育てについてのお話をする時間を確保するため、\n"
      + "メールを通して自己紹介等などのコミュニケーションを図っていただければと思います。\n\n"
      + "ご不明な点などございましたら、お気軽にお問い合わせください。\n\n"
      + "当日の家族留学が素敵な時間になりますように\n"
      + "サポートさせていただけたらと思います。\n\n"
      + "どうぞ宜しくお願い致します！\n\n"
      + "manma";

    Logger.log(mail)
    // ccにinfo.manma@gmail.comを追加
    // GmailApp.sendEmail(mail, subject, message, { name: "manma", cc: "info.manma@gmail.com" });
    // V1: 実施sent欄に送信した日付を入力
    // sheet.getRange(startRow + i, MAM_COLUMN.IS_CONFIRM_EMAIL_SENT + 1).setValue(today);

    // Make sure the cell is updated right away in case the script is interrupted
    SpreadsheetApp.flush();
  }
}
