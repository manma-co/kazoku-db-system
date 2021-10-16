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
        Logger.log(currentDate)
        Logger.log(remindEndDate)
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
        const startTime = m().timeModule.formatDate('hh:mm', new Date(row[column.START_TIME]))
        const startDate = m().timeModule.formatDate('YYYY/MM/DD', new Date(row[column.START_DATE]))
        return new Date(startDate + ' ' + startTime)
      },
      getFamilyAbroadFinishDateTime: function (row, column) {
        const finishTime = m().timeModule.formatDate('hh:mm', new Date(row[column.FINISH_TIME]))
        const startDate = m().timeModule.formatDate('YYYY/MM/DD', new Date(row[column.START_DATE]))
        return new Date(startDate + ' ' + finishTime)
      },
    }
  })()
  return {
    common: common,
  }
}

// 家族留学の詳細を学生と受け入れ家庭に連絡するscript
// 10日前に家族留学のリマインドメールを送信する
function remindFamilyAbroad(opt) {
  const options = opt || {}
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

    var familyAbroadStartDateTime = helper().common.getFamilyAbroadStartDateTime(row, MAM_COLUMN)
    if (!m().utilModule.isRemind(currentDate, familyAbroadStartDateTime, 10)) {
      logger.log("リマインド日ではないため通知しない")
      continue
    }

    // メール文面用整形
    var construction = row[MAM_COLUMN.FAMILY_CONSTRUCTION];                // F - 受け入れ家庭の家族構成
    var meetingLocation = row[MAM_COLUMN.MTG_PLACE];                      // J - 集合場所
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
      helper().common.getFamilyAbroadFinishDateTime(row, MAM_COLUMN)
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
      + "当日、よりキャリアや子育てについてのお話の時間を確保するため、\n"
      + "事前にメールを通して、自己紹介等などのコミュニケーションを図っていただければと思います。\n\n"
      + "以下、ご確認の上、本メールに【全員返信】にて、以下記載の事項を送付お願いします。\n\n"
      + "◆家族留学実施概要◆\n"
      + "実施日：" + abroadDate + "\n"
      + "集合時間：" + startTime + "\n"
      + "集合場所or接続方法：" + meetingLocation + "\n"
      + "終了予定時間：" + finishTime + "\n"
      + "参加留学生：" + studentName + "\n"
      // TODO: manmaシステムから家族構成情報を送信していない。確認事項。
      // + "ご家族構成：" + construction + "\n"
      + "緊急連絡先：\n"
      + "info.manma@gmail.com（manmaメール）\n\n"
      + "◆事前送付事項◆\n"
      + "＜受け入れ家庭/留学生共通＞\n"
      + "①自己紹介\n"
      + "→年齢、現在の所属、居住地、未婚/既婚、お子様がいる場合年齢(学年)\n"
      + "②緊急連絡先（携帯番号）\n"
      + "③(オンライン参加者のみ)接続方法について\n"
      + "当日つなぐことができるアカウント等を事前にお伝えください。\n"
      + "接続方法を変更希望の場合も本メールでやりとりをお願いします。\n"
      + "※zoomの場合は、参加者がURLを作成し、実施日までにURLをお貼りください。\n"
      + "https://00m.in/TpI5T（作成方法）\n\n"
      + "＜留学生のみ＞\n"
      + " ④家族留学の目標\n"
      + "（例：子供への接し方を学ぶこと、自分の将来の生活のヒントを得ること、◯◯さまご一家と仲良くなること など）\n"
      + "⑤聞いてみたいこと3つ\n"
      + "ご自身のキャリアプランへの不安をもとにお考えください\n"
      + "（例：結婚・出産のタイミング、両立のコツ、育児で大切にしていること）\n\n"
      + "＜受け入れ家庭のみ＞\n"
      + "⑥写真掲載について\n"
      + "留学生には家族留学後に学び・感想の提出をお願いしております。また、その他SNSにて写真と共に感想を発信していただきたいと思っております。\n"
      + "ご家族の写真掲載の可否について、以下よりご選択の上、留学生にご希望をお知らせください。\n"
      + "a.写真掲載可　b.お子さんの顔がはっきり映らなければ可　c.写真掲載不可\n\n"
      + "＊その他注意事項＊\n"
      + "①当日合流時には、留学生よりmanma宛てにメールをお願いします。\n"
      + "②万一、体調不良などで参加が難しくなりましたら、速やかに受け入れ家庭とmanmaにご連絡ください。\n"
      + "③家族留学当日に緊急連絡事項発生時には、ご家庭・留学生間でまず直接ご連絡をお願いします。\n"
      + "※上記を含めた家族留学のやりとりには、必ず【info.manma@gmail.com】をccに入れていただきますようお願いいたします。\n\n"
      + "＊家族留学当日の過ごし方ヒント＊\n"
      + "以下の資料は、家族留学当日をサポートするためのものです。参加時にご活用ください。\n"
      + "https://drive.google.com/file/d/1FMI7_DaxnGVKdgnYtlCoy-D6d__7wvTF/view?usp=sharing\n\n"
      + "また、manmaでは受け入れ家庭・参加者限定の「家族留学コミュニティ」を運営しています。\n"
      + "過去の参加・受け入れの様子を知るのに是非ご活用ください！参加後の感想投稿も大歓迎です。\n"
      + "下記のURLより参加申請をお願いいたします。\n"
      + "https://www.facebook.com/groups/289936181853224/\n"
      + "以上、ご不明な点などございましたら、お気軽にお問い合わせください。\n\n"
      + "当日の家族留学が素敵な時間になりますように\n"
      + "サポートさせていただけたらと思います。\n\n"
      + "どうぞ宜しくお願い致します！\n\n"
      + "manma";

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