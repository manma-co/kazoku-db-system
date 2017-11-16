# GAS

家族留学で利用しているGoogle Apps Scriptを管理  
※ トリガー = 実行するタイミング

## [RemindFamilyAbroad.js](RemindFamilyAbroad.js)
- 家族留学実施日の10日以内からリマインドメールを送信する
- 対象: 家庭、参加者
- トリガー
    - 家族留学実施日のの10日前以内
    - リマインドメールが未送信
    - 08:00 ~ 09:00 / 日
    
## [RemindFamilyAbroadDayBefore.js](RemindFamilyAbroadDayBefore.js)
- リマインドメールを送信する
- 対象: 参加者
- トリガー 
    - 家族留学実施日前日
    - 17:00 ~ 18:00 / 日

## [RemindSelfIntroduction.js](RemindSelfIntroduction.js)
- 自己紹介を督促するメールを送信する
- 対象: 参加者
- トリガー
    - 家族留学実施日の3日前、 5日前、7日前
    - 自己紹介メール未確認
    - 09:00 ~ 10:00 / 日

## [RemindSelfIntroductionForFamily.js](RemindSelfIntroductionForFamily.js)
- 自己紹介を督促するメールを送信する
- 対象: 家庭
- トリガー 
    - 家族留学実施日の2日前
    - 自己紹介メール未確認
    - 12:00 ~ 13:00 / 日

## [NotifyReport.js](NotifyReport.js)
- レポート提出依頼メールを送信する
- 対象: 参加者
- トリガー
    - 家族留学実施日
    - 20:00 ~ 21:00 / 日
    
## [RemindReport.js](RemindReport.js)
- 家族留学レポートを督促メールを送信する
- 対象: 参加者
- トリガー
    - レポート未確認
    - 19:00 ~ 20:00 / 日

## [RemindPayment.js](RemindPayment.js)
- 振込を督促メールを送信する
- 対象: 参加者
- トリガー
    - 家族留学実施日の5日前、9日前
    - 19:00 ~ 20:00 / 日


    
