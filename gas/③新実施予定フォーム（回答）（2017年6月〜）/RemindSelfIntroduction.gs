// 自己紹介を催促するscript
function remindSelfIntroduction() {
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
      subject: function() { return "【要確認】自己紹介メール送信のお願い" },
      body: function(name) {
        if (name === '') { return '' }
        return name + "さま\n\n"
          + "お世話になっております、manmaです。\n\n"
          + "家庭側とお繋ぎするメールは確認いただけましたでしょうか。\n"
          + "その際に、自己紹介のお願いを記載させていただいております。\n"
          + "お手数ですが、実施日も近づいてまいりましたので、ご確認の上、至急ご対応いただけたら幸いです。\n"
          + "事前にメールでコミュニケーションを多く取っておくことで、より家族留学を楽しんでいただけるかと思います。\n"
          + "お送りいただくタイミングによって、行き違いでのご連絡となっておりましたら申し訳ございません。\n"
          + "また、もしご家庭のみに送付されている場合は、 info.manma@gmail.com宛てに転送いただくようお願いします。\n\n"
          + "ご不明な点がございましたら info.manma@gmail.com までお気軽にお問い合わせください。\n"
          + "よろしくお願いいたします。\n\n"
          + "manma";
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
    var notification_date = row[MAM_COLUMN.IS_CONFIRM_EMAIL_SENT];
    if (notification_date === "") {
      continue
    }

    // 家族留学日の取得
    var sfamily_abroad_date = row[MAM_COLUMN.START_DATE]
    if (sfamily_abroad_date == "") {
      continue
    }
    var fad = new Date(sfamily_abroad_date)

    // 通知を行う日であるか？
    var is_notify = mDate.before(fad, 3) == mDate.today() || mDate.before(fad, 5) == mDate.today() || mDate.before(fad, 7) == mDate.today()
    //Logger.log("家族留学実施日: " + fad)
    //Logger.log("検証: " + before_args_day(fad, 5))
    //Logger.log("今日:" + today)
    if (!is_notify) {
      continue
    }

    Logger.log(row[MAM_COLUMN.STUDENT_EMAIL_1])
    //1人目
    var self_intro_1 = row[MAM_COLUMN.SELF_INTRO_1];
    if (self_intro_1 === "") {
      mMail.send(
        row[MAM_COLUMN.STUDENT_EMAIL_1],
        mMail.subject(),
        mMail.body(row[MAM_COLUMN.STUDENT_NAME_1])
      )
    }

    // 2人目
    var self_intro_2 = row[MAM_COLUMN.SELF_INTRO_2];
    if (self_intro_2 === "") {
      mMail.send(
        row[MAM_COLUMN.STUDENT_EMAIL_2],
        mMail.subject(),
        mMail.body(row[MAM_COLUMN.STUDENT_NAME_2])
      )
    }

    // 3人目
    var self_intro_3 = row[MAM_COLUMN.SELF_INTRO_3];
    if (self_intro_3 === "") {
      mMail.send(
        row[MAM_COLUMN.STUDENT_EMAIL_3],
        mMail.subject(),
        mMail.body(row[MAM_COLUMN.STUDENT_NAME_3])
      )
    }
  }
}