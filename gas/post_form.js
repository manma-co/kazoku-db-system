function post_contents(e) {
    var itemResponses = e.response.getItemResponses();
    var address = '';
    for (var i = 0; i < itemResponses.length; i++) {
        var itemResponse = itemResponses[i];
        var question = itemResponse.getItem().getTitle();
        var answer = itemResponse.getResponse();
        if (question == 'ご住所'){
            address = answer;
        }
    }

    var data =
        {
            "family":
                {
                    "address": address
                }
        };

    var payload = JSON.stringify(data);

    var options =
        {
            "method"  : "POST",
            "payload" : payload,
            "contentType" : "application/json",
            "followRedirects" : true,
            "muteHttpExceptions": true
        };

    var response = UrlFetchApp.fetch("https://manmasearch.herokuapp.com/locations", options);
    Logger.log(response);
}
