# To go setting page for scheduler, run `heroku addons:open scheduler`
# Refer document: https://devcenter.heroku.com/articles/scheduler
desc 'This task is called by the Heroku scheduler add-on'
task three_days_reminder_task: :environment do
  puts 'Run get_all_three_days_before_for_remind funtion for families...'
  request_logs = RequestLog.get_all_three_days_before_for_remind
  request_logs.each do |request_log|
    request_log.reply_log.each do |reply_log|
      CommonMailer.reminder_three_days(reply_log.user, request_log).deliver_now if reply_log.no_answer?
    end
  end
  puts 'done.'
end

task seven_days_over_task: :environment do
  puts 'Run seven_days_over funtion for families...'
  request_logs = RequestLog.get_all_seven_days_before_for_remind
  request_logs.each do |request_log|
    # 参加希望者に対して再打診をするかどうかのメールを送信
    CommonMailer.readjustment_to_candidate(request_log).deliver_now
    CommonMailer.readjustment_to_manma(request_log).deliver_now
  end
  puts 'done.'
end

# 月に1回学生会員にメールを送信
task monthly_news_letter: :environment do
  puts 'Run monthly news letter funtion...'
  NewsLetter.monthly_news_letter
  puts 'done.'
end

# 家庭にメールを一斉送信
task news_letter: :environment do
  puts 'Run news letter funtion...'
  NewsLetter.send_news_letter
  puts 'done.'
end
