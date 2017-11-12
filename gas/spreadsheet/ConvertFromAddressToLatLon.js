/*
 * 住所変換スクリプト
 */
function convert() {
  const COLUMN = {
    ADDRESS: 5,
    LAT: 37,
    LON: 38,
  }
  const sheetName = 'フォームの回答 1'
  const sheet = SpreadsheetApp.getActive().getSheetByName(sheetName)
  const startRow = 2
  const lastRow = sheet.getLastRow() - 1
  const lastCol = sheet.getLastColumn()

  const dataRange = sheet.getRange(startRow, 1, lastRow, lastCol);
  const data = dataRange.getValues();

  for (var i = 0; i < data.length; ++i) {
    var row = data[i]

    var latitude = row[COLUMN.LAT]
    var longitude = row[COLUMN.LON]
    // 既に変換済みの場合は何もしない
    if (latitude != "" || longitude != "") {
      continue
    }

    var location = APP.util.common.convertAddress(row[COLUMN.ADDRESS])
    Logger.log(location)
    if (typeof location === 'undefined') {
      continue
    }

    // 50回リクエストを送信したら1秒スリープする
    APP.util.common.sleepByCount(1000, 50)

    // スプレッドシートに出力
    sheet.getRange(startRow + i, COLUMN.LAT + 1).setValue(location['lat'])
    sheet.getRange(startRow + i, COLUMN.LON + 1).setValue(location['lon'])

    // Make sure the cell is updated right away in case the script is interrupted
    SpreadsheetApp.flush()
    Logger.log(row)
  }
}

// namespace
var APP = APP || {
    util: {
      common: {}
    },
  }

APP.util.common = (function () {
  /*
   *一定の回数になると1秒スリープし、カウンタが0になる
   * sleepMS: sleepする時間(ms)
   * limit: スリープするタイミング
   */
  sleepByCount = function (sleepMS, limit) {
    if (typeof limit === 'undefined') {
      // limitが引数として指定されていなければカウントしない
      return
    }

    if (typeof sleepByCount.count === 'undefined') {
      // 関数内カウンタ初期化
      sleepByCount.count = 0
    }
    if (sleepByCount.count % limit === 0 && sleepByCount.count !== 0) {
      Utilities.sleep(sleepMS)
      Logger.log('おやすみ')
    }
    sleepByCount.count += 1

    Logger.log(sleepByCount.count)
  }

  /*
   * 住所から緯度、経度を変換する
   * Google Geocoding APIにはAPIキーが必要
   * https://developers.google.com/maps/documentation/geocoding/get-api-key?hl=ja
   * 制限について
   * 2500リクエスト/日
   * 50リクエスト/秒
   * 大量に取得したい場合は、50reqごとに1秒のwaitを入れるような実装が必要
   */
  convertFromAddressToLocation = function (address) {
    if (address === '') {
      return
    }

    var api_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + encodeURI(address);
    api_url += '&key=[見せられないよ！]'
    var response = UrlFetchApp.fetch(api_url);
    var result = JSON.parse(response);
    var location = result['results'][0]
    if (typeof location === 'undefined') {
      return
    }
    location = location['geometry']['location']
    return {lat: location['lat'], lon: location['lng']}
  }

  // Public API

    sleepByCount: sleepByCount,
    convertAddress: convertFromAddressToLocation
  }
}())