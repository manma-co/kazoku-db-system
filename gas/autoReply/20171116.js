function submitForm(e) {
  var itemResponses = e.response.getItemResponses()
  // フォームの内容を保持する（manma宛に送信）
  var message = ''
  // 登録者の氏名
  var apply_name = ''
  // 登録者のメールアドレス
  var apply_mail = ''
  // これまでにmanmaのイベントや家族留学に参加したことはありますか？
  var is_member_str = ''
  // 参加日時
  var participationDate = ''
  for (var i = 0; i < itemResponses.length; i++) {
    var itemResponse = itemResponses[i]
    var question = itemResponse.getItem().getTitle()
    var answer = itemResponse.getResponse()

    if (question == 'メールアドレス') {
      apply_mail = answer
    } else if (question == 'これまでにmanmaのイベントや家族留学に参加したことはありますか？') {
      is_member_str = answer
    } else if (question == '参加日時') {
      participationDate = answer
    }
    message += (i + 1).toString() + '. ' + question + ': ' + answer + '\n'
  }
  apply_name = itemResponses[0].getResponse();

  var mUtil = (function() {
    return {
      extractMonth: function(text) {
        Logger.log(text)
        result = text.match( /(\d+)月/ )
        return result[1]
      },
      mapping: function(month) {
        if (month === '12') {
          return '3'
        } else if (month === '1') {
          return '4'
        } else if (month === '2') {
          return '5'
        }
      }
    }
  })()

  var sectionNum = mUtil.mapping(mUtil.extractMonth(participationDate))

  // manmaメンバー向けメール
  GmailApp.sendEmail('info.manma@gmail.com',
    '第' + sectionNum + '回ランチ留学応募者あり',
    '以下の内容でフォームが送信されました。\n\n' + message,
    { name: 'manmaシステム' })
  // 登録者向けメール
  var subject = ''
  var body = ''
  if (is_member_str == 'ある') {
    subject = subjectForMember()
    body = bodyForMember(apply_name, participationDate, sectionNum)
  } else {
    subject = subjectForNotMember()
    body = bodyForNotMember(apply_name, participationDate, sectionNum)
  }
  GmailApp.sendEmail(apply_mail, subject, body, { name: 'manma' });
}

// 非会員向け
function subjectForNotMember() {
  return '【manma/仮登録中】ご応募ありがとうございます'
}
function bodyForNotMember(apply_name, participationDate, sectionNum) {
  return apply_name + " 様\n"
    + "\n"
    + "この度は、第" + sectionNum + "回オフィスランチ留学＠ソフトバンクにご応募いただきありがとうございます。\n\n"
    + "\n"
    + "現在は仮登録となっています。下記の会員登録フォームへの登録が完了し次第、本イベントへの参加受付完了となりますので、忘れずにご登録ください。\n"
    + "\n"
    + "https://goo.gl/sAHgnH\n"
    + "\n"
    + "第" + sectionNum + "回ランチ留学は下記概要にて行ないます。\n"
    + "日時：" + participationDate + "\n"
    + "場所：ソフトバンク本社　25階　（東京都港区東新橋1-9-1 東京汐留ビルディング）\n"
    + "服装：自由\n"
    + "\n"
    + "集合時間・集合場所につきましては追ってご連絡いたします。\n"
    + "\n"
    + "\n"
    + "何かご不明な点がございましたら\n"
    + "inada@manma.co（担当：稲田）までご連絡ください。\n"
    + "\n"
    + "それでは当日皆様とお会いできるのを楽しみにしております。\n\n"
    + "manma\n"
}

// 会員向け
function subjectForMember() {
  return '【manma】ご応募ありがとうございます '
}
function bodyForMember(apply_name, participationDate, sectionNum) {
  return apply_name + " 様\n"
    + "この度は、第" + sectionNum + "回オフィスランチ留学＠ソフトバンクにご応募いただきありがとうございます。参加受付が完了しました。\n"
    + "\n"
    + "第2回ランチ留学は下記概要にて行ないます。\n"
    + "日時：" + participationDate + "\n"
    + "場所：ソフトバンク本社　25階　（東京都港区東新橋1-9-1 東京汐留ビルディング）\n"
    + "服装：自由\n"
    + "\n"
    + "集合時間・集合場所につきましては追ってご連絡いたします。\n"
    + "\n"
    + "\n"
    + "何かご不明な点がございましたら\n"
    + "inada@manma.co（担当：稲田）までご連絡ください。\n"
    + "\n"
    + "それでは当日皆様とお会いできるのを楽しみにしております。\n"
    + "manma"
}
