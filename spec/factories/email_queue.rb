FactoryBot.define do
  factory :email_queue do
    sender_address { 'manma@sample.com' }
    to_address { 'student@sample.com' }
    cc_address { 'sample@sample.com' }
    bcc_address { 'sample@sample.com' }
    subject { 'メールタイトル' }

    body_text { 'テキストテキスト' }
    retry_count { 0 }
    sent_status { false }
    email_type { 'matching_start' }
    time_delivered { nil }
  end
end
