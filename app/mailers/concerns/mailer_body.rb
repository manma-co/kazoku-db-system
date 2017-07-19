class MailerBody

  def self.notify_to_manma(tel_time, event, user)
    body = <<-EOS
こちらは自動配信メールです

以下の内容でマッチングが成立しました。

電話面談がある場合は速やかに確認して予定を参加家庭に連絡してください

イベント内容

イベント開始日時: [event_hold_date] ~ [event_end_time]
集合場所: [event_meeting_place]
家庭情報: [user_name]
家庭連絡先: [user_contact_email_pc]
初めての家族留学か: [event_is_first]
特記事項: [event_information] 

電話可能時間
電話可能候補日: [tel_time]

EOS
    body.sub!(/\[event_hold_date\]/, event.hold_date.strftime("%H時%M分").to_s)
    body.sub!(/\[event_end_time\]/, event.end_time.strftime("%H時%M分").to_s)
    body.sub!(/\[event_meeting_place\]/, event.meeting_place)
    body.sub!(/\[user_name\]/, user.name)
    body.sub!(/\[user_contact_email_pc\]/, user.contact.email_pc)
    body.sub!(/\[event_is_first\]/, event.is_first?)
    body.sub!(/\[event_information\]/, event.information)
    body.sub!(/\[tel_time\]/, tel_time.to_s)

    # Return
    body
  end


  def self.matching_start
    body = <<-EOS
この度、ご提出いただいた候補日でご家庭に打診を開始いたしました。


マッチングが成立いたしましたら、ご連絡させていただきますので
今しばらくお待ちください。
１週間以内にマッチングが成立しなかった場合、[manma]から再度ご連絡いたします。


＜再度日程調整 or キャンセル＞のご意向を３日以内にご回答ください。
再度、ご家庭に受け入れの打診をさせていただきます。


その他、なにかご不明な点がございましたら 
info@manma.co までお気軽にご連絡ください。

引き続き、どうぞ宜しくお願い致します。

manma
    EOS
    body.sub!(/\[manma\]/, 'manma')

    # Return
    body
  end


  def self.notify_to_family_matched(user, student, event)
    body = <<-EOS

[user_name]様


この度は、家族留学の受け入れにご協力くださり、大変ありがとうございます。

下記の内容で、家族留学の実施が確定いたしました。

今回初めて受け入れいただくご家庭には 
家族留学日以前にmanma担当者と電話にて事前説明会(所要時間10分程度)を実施します。

記載いただきました希望日時にご連絡させていただきます。
万一面談日時に都合がつかなくなった場合は
速やかにinfo@manma.coへご連絡ください。


また受け入れ前に、下記リンクより
「家族留学受け入れガイド」に改めて目を通していただくようお願いします。
https://docs.google.com/presentation/d/1B-dcCUa0PdxKyU5xlP8rvFf87oNM6BQoQEBsCD0FfTo/edit?usp=sharing

それでは、実施予定日の10日前に参加者と
お繋ぎさせていただきますので、いましばらくお待ちください。

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

参加者名: [student_name] さん
参参加者の所属名: [student_belongs]
 参加者の連絡先: [student_emergency] 
実施日時: [event_hold_date]
実施開始時間: [event_start_time]
実施終了時間: [event_end_time]
集合場所: [event_meeting_place] 

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

また、お子さんの体調不良等で急な予定の変更がある場合は
info@manma.co までご連絡ください。

実施日の過ごし方やその他受け入れにあたり
ご質問などございましたらお気軽にご連絡ください。
引き続き、どうぞよろしくお願いいたします。


manma

    EOS

    body.sub!(/\[user_name\]/, user.name)
    body.sub!(/\[student_name\]/, student.name)
    body.sub!(/\[student_belongs\]/, student.belongs)
    body.sub!(/\[student_emergency\]/, student.emergency)
    body.sub!(/\[event_hold_date\]/, event.hold_date.strftime("%H時%M分").to_s)
    body.sub!(/\[event_start_time\]/, event.start_time.strftime("%H時%M分").to_s)
    body.sub!(/\[event_end_time\]/, event.end_time.strftime("%H時%M分").to_s)
    body.sub!(/\[event_meeting_place\]/, event.meeting_place)

    # Return
    body
  end


  def self.notify_to_candidate(event, log, user)

    body = <<-EOS

[log_name] 様

この度、家族留学のマッチングが成立いたしましたのでご連絡させていただきます。</p>

キャンセルは原則として不可となります。
止むを得ない事情でキャンセルされる方は
至急 info@manma.co に理由を明記の上、ご連絡ください。

下記の内容で、家族留学を実施させていただきます。

実施予定日の10日前にご家庭とお繋ぎさせていただきます。
スケジュールを確保のうえ、いましばらくお待ち下さい。

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

受け入れ家庭のお名前: [user_name]
受け入れ家庭の家族構成: [user_job_style_str]
受け入れ家庭の緊急連絡先: [user_contact_email_pc]
実施日時: [event_hold_date]
実施開始時間: [event_start_time]
実施終了時間: [event_end_time]
集合場所: [event_meeting_place]
備考: [event_information]
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

また、ご質問等ございましたら
info@manma.co までご連絡ください。

引き続き、どうぞよろしくお願いいたします。

manma

    EOS

    body.sub!(/\[log_name\]/, log.name)
    body.sub!(/\[user_name\]/, user.name)
    body.sub!(/\[user_job_style_str\]/, user.job_style_str)
    body.sub!(/\[user_contact_email_pc\]/, user.contact.email_pc)
    body.sub!(/\[event_hold_date\]/, event.hold_date.strftime("%H時%M分").to_s)
    body.sub!(/\[event_start_time\]/, event.start_time.strftime("%H時%M分").to_s)
    body.sub!(/\[event_end_time\]/, event.end_time.strftime("%H時%M分").to_s)
    body.sub!(/\[event_meeting_place\]/, event.meeting_place)
    body.sub!(/\[event_information\]/, event.information)

    # Return
    body
  end
  

end