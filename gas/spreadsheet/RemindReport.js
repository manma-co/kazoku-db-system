// レポートを催促するscript
// 20170830 composed by shino
function remaind_report_Function(){
  var FORM_MAM_COLUMN = {
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
  sent_remind_report_Function("フォームの回答", FORM_MAM_COLUMN);
}

function sent_remind_report_Function(sheets,MAM_COLUMN){
  var sheet = SpreadsheetApp.getActive().getSheetByName(sheets)
  var startRow = 2;  // First row of data to process
  var lastRow = sheet.getLastRow() - 1
  var lastCol = sheet.getLastColumn()

  var today = Utilities.formatDate(new Date(), 'JST', 'yyyy/MM/dd');
  var dataRange = sheet.getRange(startRow, 1, lastRow, lastCol);
  var data = dataRange.getValues();
  for (var i = 0; i < data.length; ++i) {
    var row = data[i]

    var notification_date = row[MAM_COLUMN.IS_CONFIRM_EMAIL_SENT]
    if (notification_date === "") {
      continue
    }

    // 家族留学日の取得
    var sfamily_abroad_date = row[MAM_COLUMN.START_DATE]
    if (sfamily_abroad_date == "") {
      continue
    }
    // 家族留学日
    var fad = new Date(sfamily_abroad_date);

    // リマインドメールを送信する日でなければメールを送信しない
    var is_notify = after_args_day(fad, 3) == today || after_args_day(fad, 5) == today || after_args_day(fad, 7) == today
    Logger.log("家族留学実施日: " + fad)
    Logger.log("検証: " + after_args_day(fad, 2))
    Logger.log("今日:" + today)
    if (!is_notify) {
      continue
    }

    // 1人目
    var report_flag_1 = row[MAM_COLUMN.REPORT_1];
    if (report_flag_1 === ""){
      mail_remind_report(row[MAM_COLUMN.STUDENT_EMAIL_1], row[MAM_COLUMN.STUDENT_NAME_1])
    }
    // 2人目
    var report_flag_2 = row[MAM_COLUMN.REPORT_2];
    if (report_flag_2 === ""){
      mail_remind_report(row[MAM_COLUMN.STUDENT_EMAIL_2], row[MAM_COLUMN.STUDENT_NAME_2])
    }
    // 3人目
    var report_flag_3 = row[MAM_COLUMN.REPORT_3];
    if (report_flag_3 === ""){
      mail_remind_report(row[MAM_COLUMN.STUDENT_EMAIL_3], row[MAM_COLUMN.STUDENT_NAME_3])
    }
  }
}

// dateの日付からafter日後を取得する
function after_args_day(date, after) {
  return Utilities.formatDate((new Date((date.getTime()) + (60*60*24*1000) * after)), 'JST', 'yyyy/MM/dd');
}

function mail_remind_report(student_mail, student_name) {
  if (student_mail === "" || student_name === "") {
    return
  }
  Logger.log("メールを" + student_name + "に送信")
  GmailApp.sendEmail(student_mail, get_subject_remind_report(), get_message_remind_report(student_name), {name: 'manma'})
}

function get_subject_remind_report() {
  return "【manma】参加後レポートの提出のご確認"
}

function get_message_remind_report(student_name) {
  return student_name + "さま\n\n"
    + "お世話になっております、manmaです。\n\n"
    + "先日ご案内いたしましたフォームへのご記入をよろしくお願いいたします。\n\n"
    + "家族留学は“家族留学の学び”をフォームにご記入いただいたのち、正式に終了とさせていただきますので、下記のフォームよりご記入くださいませ。\n\n"
    + "また、家族留学終了後は、参加者より受け入れてくださったご家族に、お礼のメールをお送りいただきたく思います。\n"
    + "行き違いでのご連絡となっておりましたら申し訳ございません。\n"
    + "▷▷▷ http://goo.gl/forms/YQCfdw4sSQ\n"
    + "何卒よろしくお願いいたします。\n\n"
    + "manma";
}