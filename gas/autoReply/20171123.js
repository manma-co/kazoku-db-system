function submitForm(e) {
  const KEY = {
    MAIL: 'メールアドレス',
    IS_MEMBER_STR: 'これまでにmanmaのイベントや家族留学に参加したことはありますか？',
    ATTEND_DATE: '参加日時',
    NAME: '名前',
    MANMA_MAIL_BODY: 'manmaへ送信する内容'
  }

  const itemResponses = e.response.getItemResponses()
  const box = {}
  for (var i = 0; i < itemResponses.length; i++) {
    var itemResponse = itemResponses[i]
    var title = itemResponse.getItem().getTitle()
    var answer = itemResponse.getResponse()

    if (title === KEY.MAIL) {
      box[KEY.MAIL] = answer
    } else if (title === KEY.IS_MEMBER_STR) {
      box[KEY.IS_MEMBER_STR] = answer
    } else if (title === KEY.ATTEND_DATE) {
      box[KEY.ATTEND_DATE] = answer
    } else if (title === KEY.NAME) {
      box[KEY.NAME] = answer
    }
    box[KEY.MANMA_MAIL_BODY] = (box[KEY.MANMA_MAIL_BODY] || '') + (i + 1).toString() + '. ' + title + ': ' + answer + '\n'
  }

  const mUtil = (function() {
    return {
      extractMonth: function(text) {
        // 月の前にある数値を抽出
        const result = text.match( /(\d+)月/ )
        return result[1]
      },
      mapping: function(month) {
        // 月と対応する回数のマッピング
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

  const mContent = (function() {
    return {
      subject: function(options) {
        return options.isMember ? '【manma】ご応募ありがとうございます' : '【manma/仮登録中】ご応募ありがとうございます'
      },
      body: function(options) {
        if (options.isMember) {
          return options.name + " 様\n"
            + "この度は、第" + options.sectionNum + "回オフィスランチ留学＠ソフトバンクにご応募いただきありがとうございます。参加受付が完了しました。\n"
            + "\n"
            + "第" + options.sectionNum + "回ランチ留学は下記概要にて行ないます。\n"
            + "日時：" + options.date + "\n"
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
        } else {
          return options.name + " 様\n"
            + "\n"
            + "この度は、第" + options.sectionNum + "回オフィスランチ留学＠ソフトバンクにご応募いただきありがとうございます。\n\n"
            + "\n"
            + "現在は仮登録となっています。下記の会員登録フォームへの登録が完了し次第、本イベントへの参加受付完了となりますので、忘れずにご登録ください。\n"
            + "\n"
            + "https://goo.gl/sAHgnH\n"
            + "\n"
            + "第" + options.sectionNum + "回ランチ留学は下記概要にて行ないます。\n"
            + "日時：" + options.date + "\n"
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
      }
    }
  })()

  const mMail = (function() {
    return {
      send: function(options) {
        if (options.email === '' || options.subject === '' || options.body === ''){ return }
        Logger.log(options.email + "に送信"); Logger.log(options.subject); Logger.log(options.body)
        GmailApp.sendEmail(options.email, options.subject, options.body, options.cc)
      }
    }
  })()

  // 月に対応する開催回数の取得
  const sectionNum = mUtil.mapping(mUtil.extractMonth(box[KEY.ATTEND_DATE]))

  // manma向けメール送信
  mMail.send({
    email: 'info.manma@gmail.com',
    subject: '第' + sectionNum + '回ランチ留学応募者あり',
    body: '以下の内容でフォームが送信されました。\n\n' + box[KEY.MANMA_MAIL_BODY],
    cc :{ name: 'manmaシステム' }
  })

  // 登録者向けメール
  const isMember = box[KEY.IS_MEMBER_STR] === 'ある'
  mMail.send({
    email: box[KEY.MAIL],
    subject: mContent.subject({ isMember: isMember }),
    body: mContent.body({
      isMember: isMember,
      sectionNum: sectionNum,
      name: box[KEY.NAME],
      date: box[KEY.ATTEND_DATE]
    }),
    cc: { name: 'manma'}
  })
}
