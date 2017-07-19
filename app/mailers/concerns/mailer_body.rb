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
    body.sub!(/\[event_hold_date\]/, event.hold_date.to_s)
    body.sub!(/\[event_end_time\]/, event.end_time.to_s)
    body.sub!(/\[event_meeting_place\]/, event.meeting_place)
    body.sub!(/\[user_name\]/, user.name)
    body.sub!(/\[user_contact_email_pc\]/, user.contact.email_pc)
    body.sub!(/\[event_is_first\]/, event.is_first?)
    body.sub!(/\[event_information\]/, event.information)
    body.sub!(/\[tel_time\]/, tel_time.to_s)

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

    body
  end

end