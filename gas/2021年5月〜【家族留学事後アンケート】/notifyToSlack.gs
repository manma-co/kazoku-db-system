function Main(e) {
  var itemResponses = e.response.getItemResponses();
  var message = '';
  var mention = '';

  for (var i = 0; i < itemResponses.length; i++) {
    var itemResponse = itemResponses[i];
    var question = itemResponse.getItem().getTitle();
    var answer = itemResponse.getResponse();

    message += (i + 1).toString() + '. ' + question + ': ' + answer + '\n';
  }

  var options = {
    channel: "家族留学レポート", //チャンネル名
    message: message
  }
  postToSlack(options)
}

function postToSlack(options) {
  /**
   * 指定されたチャネルにメッセージを送信する
   */
  const slackModule = (function() {
    const webhookurl = "https://hooks.slack.com/services/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";
    const botName = "家族留学レポート通知bot" // 通知するロボットの名前
    const botIcon = ":manma:" // 通知するロボットのアイコン
    return {
      exec: function(options) {
        var jsonData = {
          "channel": options.channel || "家族留学レポート",
          "username": options.botName || botName,
          "text": options.message || "メッセージの内容は空です",
          "icon_emoji": options.botIcon || botIcon
        };
        var payload = JSON.stringify(jsonData);
        var config = {
          "method" : "post",
          "payload" : payload
        };
        UrlFetchApp.fetch(webhookurl, config);
      }
    }
  })()

  slackModule.exec(options)
}

function test() {
  var options = {
    message: '送信テスト',
    channel: '家族留学レポート'
  }
  postToSlack(options)
}