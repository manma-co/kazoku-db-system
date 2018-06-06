/**
 * Created by shino on 2018/04/25.
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
        var current_time_ms = getCurrentTimeMilliSecond(currentDate)
        // currentDateから1日後
        return new Date(current_time_ms + (60 * 60 * 24 * 1000) * numDays);
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

/**
 * 面談希望日時の3日前にリマインド
 * Created by shino on 2018/04/25
 * 対応シート: https://docs.google.com/spreadsheets/d/1uT8esOFL2Qf9M1VWPggFkXzYMap0ngcDieBIv7tqNEg/edit#gid=1316265234
 */
function remind(options) {
  const column = {
    NAME: 2, // C1: 氏名
    EMAIL: 5, // F2: メールアドレス
    INTERVIEW_DATE: 15,  // P1: 面談希望日時（場所：JR大塚駅付近）
    INTERVIEW_DATE_ONLINE: 17, // R1: 面談希望日時
    IS_REMIND: 20  // U1: リマインドメール送信済み確認(システム利用)
  }

  // DI
  const COLUMN = options.COLUMN || column
  const spreadSheetApp = options.SpreadsheetApp || SpreadsheetApp
  const gmailApp = options.GmailApp || GmailApp
  const logger = options.Logger || Logger
  const currentDate = options.currentDate || new Date()
  // 処理位置の決定
  // 2行目から処理を開始(1行目はヘッダ)
  const startRow = (options.startRow !== undefined) ? options.startRow : 2

  const SHEET_NAME = 'フォームの回答'
  const SUBJECT = '【リマインド】家族留学の事前面談について'
  const MANMA_MAIL = 'info.manma@gmail.com'

  // 情報を取得するシートの決定
  const sheet = spreadSheetApp.getActive().getSheetByName(SHEET_NAME)
  const lastRow = sheet.getLastRow() - 1
  const lastCol = sheet.getLastColumn()
  const dataRange = sheet.getRange(startRow, 1, lastRow, lastCol)
  const data = dataRange.getValues()

  for (var i = 0; i < data.length; i++) {
    var row = data[i]
    var isRemind = row[COLUMN.IS_REMIND]
    // 送信済みであれば何もしない
    if (isRemind !== '') {
      continue
    }

    var interviewDateStr = row[COLUMN.INTERVIEW_DATE]
    var interviewDateOnlineStr = row[COLUMN.INTERVIEW_DATE_ONLINE]

    if (interviewDateStr === '' && interviewDateOnlineStr === '') {
      logger.log('日付が空なのでスルー')
      continue
    }

    var targetDateStr = ''
    if (interviewDateStr !== '') {
      targetDateStr = interviewDateStr
    }
    if (interviewDateOnlineStr !== '') {
      targetDateStr = interviewDateOnlineStr
    }
    // 2017年7月1日 10:00~ という文字列を 2017/7/1 10:00 に変換する
    var interviewDate = convertDate(targetDateStr)
    interviewDate = m().timeModule.convertDatetimeToDate(interviewDate)

    var isNeedRemind = m().utilModule.isRemind(currentDate, interviewDate, 3)
    if (!isNeedRemind) {
      logger.log('リマインド対象日ではないのでスルー')
      continue
    }

    // リマインドメール送信
    var name = row[COLUMN.NAME]
    var email = row[COLUMN.EMAIL]
    logger.log(email)
    var content = getMailContent(name, interviewDateStr)
    gmailApp.sendEmail(email, SUBJECT, content, { name: 'manma', cc: MANMA_MAIL });
    sheet.getRange(startRow + i, COLUMN.IS_REMIND + 1).setValue(
      m().timeModule.formatDate('YYYY/MM/DD', currentDate)
    )
    spreadSheetApp.flush();
  }
}

// 2017年7月1日 10:00~ の形式の文字列を 2017/7/1 10:00 に変換する
// @return [Date] 変換されたDate型
function convertDate(dateStr) {
  dateStr = m().commonModule.splitTilde(dateStr)[0]
  dateStr = m().commonModule.convertFromJPStrDateToCommonDateStr(dateStr)
  return new Date(dateStr)
}

function getMailContent(name, interview_date) {
  return ""
    + name + " 様\n"
    + "\n"
    + "この度は、家族留学への参加申し込みをいただきありがとうございます。\n"
    + "\n"
    + "下記日程で、面談を実施させていただきます。\n"
    + "内容をご確認の上、ご参加をお待ちしております。\n"
    + "\n"
    + "・面談日時\n"
    + interview_date + " \n"
    + "\n"
    + "・面談場所\n"
    + "▼対面\n"
    + "  RYOZAN PARK 大塚\n"
    + "〒170-0005 東京都豊島区南大塚3-36-7 南大塚T&Tビル５F\n"
    + "※到着されましたら「507」の呼び鈴を鳴らしてください\n"
    + "▼オンライン\n"
    + "  ご記入頂いたSkypeもしくはFacebookをオンラインにしてお待ち下さい\n"
    + "\n"
    + "・持ち物\n"
    + "  身分証明書（初回参加の方のみ）\n"
    + "\n"
    + "・内容\n"
    + "①事前説明会（初回参加の方のみ）\n"
    + "②家族留学マッチング\n"
    + "※条件をお伺いし、面談日から３週間～２ヶ月の日程で家族留学を調整致します\n"
    + "\n"
    + "・参加費\n"
    + "  実施日が確定次第お振込頂きます\n"
    + "\n"
    + "日程変更は原則としてお受けできません。\n"
    + "キャンセルをされる場合は、info@manma.co までご連絡の上\n"
    + "改めて下記リンクより面談をお申込みください。\n"
    + "http://manma.co/student/\n"
    + "\n"
    + "ご不明な点がございましたら\n"
    + "info@manma.co（久保）までお気軽にご連絡ください。\n"
    + "\n"
    + "お会いできますことを、楽しみにしております。\n"
}

module.exports = {
  remind,
  convertDate,
}
