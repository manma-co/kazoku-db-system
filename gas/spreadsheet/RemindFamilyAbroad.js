/**
 * 共通関数モジュール
 */
function m() {
  /* timeModule */
  const timeModule = (function () {
    const getCurrentTimeMilliSecond = function (currentDate) {
      // 今日の日付をフォーマットして取得
      var year = currentDate.getFullYear()
      var month = currentDate.getMonth()
      var day = currentDate.getDate()
      return new Date(year, month, day).getTime()
    }
    return {
      formatDate: function (format, date) {
        if (!format) format = 'YYYY-MM-DD hh:mm:ss.SSS';
        format = format.replace(/YYYY/g, date.getFullYear());
        format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
        format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2));
        format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
        format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
        format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
        if (format.match(/S/g)) {
          var milliSeconds = ('00' + date.getMilliseconds()).slice(-3);
          var length = format.match(/S/g).length;
          for (var i = 0; i < length; i++) format = format.replace(/S/, milliSeconds.substring(i, i + 1));
        }
        return format;
      },
      // @param [int] currentDateの日付から num_days 日後
      // @return [Date] currentDateから1日後のDate
      getArgsDaysLater: function (currentDate, numDays) {
        var currentTimeMilliSecond = getCurrentTimeMilliSecond(currentDate)
        // currentDateから1日後
        return new Date(currentTimeMilliSecond + (60 * 60 * 24 * 1000) * numDays);
      },
      // @return [long] 今日の日付 0時のms
      getCurrentTimeMilliSecond: function (currentDate) {
        return getCurrentTimeMilliSecond(currentDate)
      },
      // DatetimeをDateに変換
      // @return [Date]
      convertDatetimeToDate: function (datetime) {
        var year = datetime.getFullYear();
        var month = datetime.getMonth();
        var day = datetime.getDate();
        return new Date(year, month, day)
      },
    }
  })()

  const utilModule = (function () {
    return {
      /**
       * リマインドする日かどうか判定する
       * remindEndDate - beforeDays <= cunrretDateならリマインドする
       * @param {Date} currentDate 現在の日付
       * @param {Date} remindEndDate リマインド終了日(面談当日の日付)
       * @param {Date} beforeDays 減算する日付
       * @return {Boolean} リマインドするかどうか
       */
      isRemind: function (currentDate, remindEndDate, beforeDays) {
        var remindStartDate = timeModule.getArgsDaysLater(remindEndDate, -beforeDays)
        return remindStartDate.getTime() <= currentDate.getTime() && currentDate.getTime() <= remindEndDate.getTime()
      },
    }
  })()

  /* Common */
  const commonModule = (function () {
    return {
      removeTilde: function (str) {
        return str.replace(/~/g, '');
      },
      splitTilde: function (str) {
        return str.split('~')
      },
      // yyyy年mm月dd日 を yyyy/mm/dd に変換
      convertFromJPStrDateToCommonDateStr: function (dateStr) {
        dateStr = dateStr.replace(/年/g, '/')
        dateStr = dateStr.replace(/月/g, '/')
        return dateStr.replace(/日/g, '')
      },
    }
  })()

  return {
    timeModule: timeModule,
    utilModule: utilModule,
    commonModule: commonModule,
  }
}

function helper() {
  const common = (function () {
    return {
      canFamilyAbroad: function (row, column) {
        return row[column.CAN_FAMILY_ABROAD] === 'はい'
      },
      isEmailSent: function (row, column) {
        return row[column.IS_CONFIRM_EMAIL_SENT] !== ''
      },
      getStudentName: function (row, column) {
        // 複数人対応するために studentName に　"さま"を付与する
        var studentName = row[column.STUDENT_NAME_1] + "さま";
        if (row[column.STUDENT_NAME_2] !== "") {
          studentName = studentName + "," + row[column.STUDENT_NAME_2] + "さま";
        }
        if (row[column.STUDENT_NAME_3] !== "") {
          studentName = studentName + "," + row[column.STUDENT_NAME_3] + "さま";
        }
        return studentName
      },
      getStudentEmail: function (row, column) {
        var studentEmail = row[column.STUDENT_EMAIL_1]
        if (row[column.STUDENT_EMAIL_2] != "") {
          studentEmail = studentEmail + "," + row[column.STUDENT_EMAIL_2];
        }
        if (row[column.STUDENT_EMAIL_3] != "") {
          studentEmail = studentEmail + "," + row[column.STUDENT_EMAIL_3];
        }
        return studentEmail
      },
      getFamilyAbroadStartDateTime: function (row, column) {
        if (typeof row[column.START_TIME] === 'string') {
          return new Date(row[column.START_DATE] + ' ' + row[column.START_TIME])
        } else {
          const startTime = m().timeModule.formatDate('hh:mm', new Date(row[column.START_TIME]))
          const startDate = m().timeModule.formatDate('YYYY/MM/DD', new Date(row[column.START_DATE]))
          return new Date(startDate + ' ' + startTime)
        }
      },
      getFamilyAbroadFinishDateTime: function (row, column) {
        if (typeof row[column.FINISH_TIME] === 'string') {
          return new Date(row[column.START_DATE] + ' ' + row[column.FINISH_TIME])
        } else {
          const finishTime = m().timeModule.formatDate('hh:mm', new Date(row[column.FINISH_TIME]))
          const startDate = m().timeModule.formatDate('YYYY/MM/DD', new Date(row[column.START_DATE]))
          return new Date(startDate + ' ' + startTime)
        }
      },
    }
  })()
  return {
    common,
  }
}

// 家族留学の詳細を学生と受け入れ家庭に連絡するscript
// 10日前に家族留学のリマインドメールを送信する
function remindFamilyAbroad(options) {
  // フォーム回答の場合を実行
  const COLUMN = {
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

  // DI
  const MAM_COLUMN = options.COLUMN || COLUMN
  const spreadSheetApp = options.SpreadsheetApp || SpreadsheetApp
  const gmailApp = options.GmailApp || GmailApp
  const logger = options.Logger || Logger
  const currentDate = options.currentDate || new Date()
  // 処理位置の決定
  // 2行目から処理を開始(1行目はヘッダ)
  const startRow = (options.startRow !== undefined) ? options.startRow : 2

  // スプレッドシート情報準備
  const sheetName = 'フォームの回答'
  // シート情報取得
  const sheet = spreadSheetApp.getActive().getSheetByName(sheetName)
  const lastRow = sheet.getLastRow() - 1;
  const lastCol = sheet.getLastColumn();
  const dataRange = sheet.getRange(startRow, 1, lastRow, lastCol);
  const data = dataRange.getValues();
  for (var i = 0; i < data.length; ++i) {
    var row = data[i];

    // メールは送信済みか？(V1: 実施sent欄)
    if (helper().common.isEmailSent(row, MAM_COLUMN)) {
      logger.log("メールが送信されている記録があるため通知しない");
      continue
    }
    // 家族留学受け入れ可能か？
    if (!helper().common.canFamilyAbroad(row, MAM_COLUMN)) {
      continue
    }

    var family_name = row[MAM_COLUMN.FAMILY_NAME];                         // E - 受け入れ家庭のお名前
    var family_mail = row[MAM_COLUMN.FAMILY_EMAIL];                        // G - 受け入れ家庭のご連絡先
    if (family_mail === "") {
      logger.log("家庭用メールが空なので通知しない")
      continue
    }
    var studentName = helper().common.getStudentName(row, MAM_COLUMN)
    var studentEmail = helper().common.getStudentEmail(row, MAM_COLUMN)
    if (studentEmail === "") {
      logger.log("学生メールが空なので通知しない")
      continue
    }

    var familyAbroadStartDateTime = new Date(helper().common.getFamilyAbroadStartDateTime(row, MAM_COLUMN))
    if (!m().utilModule.isRemind(currentDate, familyAbroadStartDateTime, 10)) {
      logger.log("リマインド日ではないため通知しない")
      continue
    }

    // メール文面用整形
    var construction = row[MAM_COLUMN.FAMILY_CONSTRUCTION]                // F - 受け入れ家庭の家族構成
    var meetingLocation = row[MAM_COLUMN.MTG_PLACE]                      // J - 集合場所
    var abroadDate = m().timeModule.formatDate(
      'YYYY/MM/DD',
      familyAbroadStartDateTime
    )
    var startTime = m().timeModule.formatDate(
      'hh:mm',
      familyAbroadStartDateTime
    )
    var finishTime = m().timeModule.formatDate(
      'hh:mm',
      new Date(helper().common.getFamilyAbroadFinishDateTime(row, MAM_COLUMN))
    )

    var mail = family_mail + "," + studentEmail + "," + ""
    var subject = "【manma】家族留学当日のお知らせ";
    var message = "受け入れ家庭\n"
      + family_name + "さま\n\n"
      + "留学生\n"
      + studentName + "\n\n"
      + "お世話になっております。"
      + "家族留学実施日が近づいてまいりましたので、\n\n"
      + "manmaより、当日についてご連絡いたします。\n\n"
      + "◆家族留学実施概要◆\n"
      + "実施日：" + abroadDate + "\n"
      + "集合時間：" + startTime + "\n"
      + "集合場所：" + meetingLocation + "\n"
      + "終了予定時間：" + finishTime + "\n"
      + "参加留学生：" + studentName + "\n"
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
      + "・当日合流された場合は、こちらのメールに返信する形でご一報くださいませ。\n"
      + "特に解散時には、学生のみなさんより当日の写真を添付してmanmaにご連絡していただきますようお願いいたします。\n"
      + "manmaにメールを送信したことを確認したのち、帰宅されてください。\n"
      + "・学生のみなさまには実施日翌日までに、ご家庭へのお礼・感想メールをお送りいただくようにお願いしております。\n"
      + "下記の項目を含め、できるだけ詳細にご記入ください。\n\n"
      + "---------------------------記入事項-----------------------------\n\n"
      + "〈家族留学を通してきづいたことや学び（３つほど）〉\n"
      + "〈家族留学を通じて変わったこと、変わらなかったことなど感想〉\n"
      + "------------------------------------------------------------------------\n\n"
      +
      + "・家族留学後に簡単なアンケートへのご協力をお願いしております。\n"
      + "実施日当日の夜に再度メールでご連絡いたしますので、翌日までにご回答いただけますと幸いです。\n"
      + "▷▷▷受け入れ家庭の方\n"
      + "https://docs.google.com/forms/d/e/1FAIpQLScDKSkR-A5T2FR9O6t19zMMoUES2RkfYlNwOt3e7UCT6DELtw/viewform\n"
      + "\n"
      + " ▷▷▷参加者の方\n"
      + " https://docs.google.com/forms/d/e/1FAIpQLSfnCKgCFHtdUKAxXC_zEi_qn1WftKkLVn0eTPm4LrisAkkrrQ/viewform\n"
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
      + "manma"

    logger.log('メールが送信される↓')
    logger.log(mail)
    // ccにinfo.manma@gmail.comを追加
    gmailApp.sendEmail(mail, subject, message, { name: "manma", cc: "info.manma@gmail.com" });
    // V1: 実施sent欄に送信した日付を入力
    sheet.getRange(startRow + i, MAM_COLUMN.IS_CONFIRM_EMAIL_SENT + 1).setValue(
      m().timeModule.formatDate('YYYY/MM/DD', currentDate)
    )

    // Make sure the cell is updated right away in case the script is interrupted
    spreadSheetApp.flush();
  }
}

module.exports = {
  helper,
  remindFamilyAbroad,
}