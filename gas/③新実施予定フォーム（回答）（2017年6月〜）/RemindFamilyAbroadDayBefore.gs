/*
 * 家族留学前日にリマインドメールを送信する
 * composed by shinocchi 20171115
 */
function remindFamilyAbroadDayBefore() {
  // フォーム回答の場合を実行
  const MAM_COLUMN = {
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
    MAM_CHECK: 18,  // S1 manmaチェック欄
    IS_EMAIL_SENT: 19,  // T1 sent欄
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

  const mMail = (function () {
    return {
      subject: function () {
        return "【manma】明日の家族留学について"
      },
      body: function (student_name, f_family_abroad_date, f_family_abroad_datetime, meeting_location, f_family_abroad_finish_time) {
        return "\
@@\n\
\n\
こんばんは。\n\
いよいよ明日は家族留学です！\n\
\n\
再度、【時間・集合場所or接続方法】をご確認の上、遅刻がないようお気をつけください。\n\
◆家族留学実施概要◆\n\
実施日：@@\n\
開始時間：@@\n\
集合場所or接続方法：@@\n\
終了予定時間：@@\n\
\n\
以下は当日の注意事項ですので、ご一読お願いします。\n\
\n\
  ●当日、ご家庭とお会いできないなど緊急の件ありましたら、まずご家庭の緊急連絡先へご連絡の上、ご対応お願いします。\n\
\n\
  ●ご家庭の方と合流した際にmanmaに報告メールをお願いいたします。\n\
\n\
  ●解散後、受け入れ家庭の方にお礼メールを忘れずに送るようにしてください。\n\
その際、manmaをccに入れるのを忘れないようにお願い致します。\n\
\n\
  ●家族留学後にfacebook「家族留学コミュニティ」グループにて、学び・感想の投稿をよろしくお願い致します。\n\
\n\
上記4点、どうぞよろしくお願いいたします。\n\
\n\
それでは、明日が素敵な1日になることを願っております。\n\
\n\
manma\n".at(
          student_name, f_family_abroad_date, f_family_abroad_datetime, meeting_location, f_family_abroad_finish_time
        )
      },
      send: function (email, subject, body) {
        if (email === "") {
          return
        }
        // Logger.log(email + "に送信"); Logger.log(subject); Logger.log(body)
        GmailApp.sendEmail(email, subject, body, { name: "manma", cc: "info.manma@gmail.com" })
      }
    }
  })()

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

  const in_one_day = mDate.after(mDate.todayOfDateType(), 1, false)
  const data = mSheet.values()
  for (var i = 0; i < data.length; ++i) {
    var row = data[i];

    var status = row[MAM_COLUMN.CAN_FAMILY_ABROAD];
    if (status == "いいえ") {
      continue
    }

    // 複数人対応するために student_name に　"さま"を付与する
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

    var family_name = row[MAM_COLUMN.FAMILY_NAME];                         // E - 受け入れ家庭のお名前
    var construction = row[MAM_COLUMN.FAMILY_CONSTRUCTION];                // F - 受け入れ家庭の家族構成
    var family_mail = row[MAM_COLUMN.FAMILY_EMAIL];                        // G - 受け入れ家庭のご連絡先
    var family_abroad_date = new Date(row[MAM_COLUMN.START_DATE]);         // H - 実施日時
    var family_abroad_datetime = new Date(row[MAM_COLUMN.START_TIME]);     // I - 実施開始時間
    var meeting_location = row[MAM_COLUMN.MTG_PLACE];                      // J - 集合場所
    var family_abroad_finish_time = new Date(row[MAM_COLUMN.FINISH_TIME]); // N - 実施終了時間

    var family_abroad_time = family_abroad_date.getTime()  // 家族留学実施日ms秒

    // 日付算: new Date(0) = 1970/01/01
    var diff_in_one_day_abroad = in_one_day - family_abroad_time     // 今日から1日後のms秒 - 家族留学実施の日付のms秒

    if (diff_in_one_day_abroad != 0) {
      Logger.log(diff_in_one_day_abroad)
      // Logger.log(student_mail)
      // Logger.log("家族留学実施日の1日前ではないので送信しない");
      continue
    }
    if (family_mail === "") {
      // Logger.log("家庭用メールが空なので通知しない")
      continue
    }
    if (student_mail === "") {
      // Logger.log("学生メールが空なので通知しない")
      continue
    }

    // 日付を指定の書式に変換
    var f_family_abroad_date = Utilities.formatDate(family_abroad_date, 'JST', 'yyyy/MM/dd');
    var f_family_abroad_datetime = Utilities.formatDate(family_abroad_datetime, 'JST', 'HH:mm');
    var f_family_abroad_finish_time = Utilities.formatDate(family_abroad_finish_time, 'JST', 'HH:mm');

    mMail.send(
      student_mail,
      mMail.subject(),
      mMail.body(student_name, f_family_abroad_date, f_family_abroad_datetime, meeting_location, f_family_abroad_finish_time)
    )
  }
}

function convertAt() {
  var i = 0, args = arguments;
  return this.replace(/@@/g, function () { return args[i++] })
}

String.prototype.at || Object.defineProperty(String.prototype, "at", {value: convertAt})
