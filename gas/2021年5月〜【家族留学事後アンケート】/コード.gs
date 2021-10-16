function slack_submitForm(e){
  var itemResponses = e.response.getItemResponses();
  var message = '';
  for (var i = 0; i < itemResponses.length; i++) {
    var itemResponse = itemResponses[i];
    var question = itemResponse.getItem().getTitle();
    var answer = itemResponse.getResponse();
    message += (i + 1).toString() + '. ' + question + ': ' + answer + '\n';
  }
  var webhookurl = "https://hooks.slack.com/services/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";
  var botName = "report"; // 通知するロボットの名前
  var botIcon = ":manma:"; // 通知するロボットのアイコン
  var channel = "#contactsupport" //チャンネル名

 
  postMsgToSlack(message, botName, botIcon, channel, webhookurl);
 
} 
function postMsgToSlack(msg, username, icon_emoji, channel, url) {
  var jsonData = {
    "channel": channel,
    "username": username === undefined ? "" : username,
    "text": msg,
    "icon_emoji": icon_emoji === undefined ? "" : icon_emoji
  };
  var payload = JSON.stringify(jsonData);
  var options = {
    "method" : "post",
    "payload" : payload
  };
  UrlFetchApp.fetch(url, options);
}