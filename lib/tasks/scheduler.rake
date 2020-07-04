# To go setting page for scheduler, run `heroku addons:open scheduler`
# Refer document: https://devcenter.heroku.com/articles/scheduler
desc 'This task is called by the Heroku scheduler add-on'
task three_days_reminder_task: :environment do
  puts 'Run all_three_days_before_for_remind funtion for families...'
  study_abroads = StudyAbroad.all_three_days_before_for_remind
  study_abroads.each do |study_abroad|
    study_abroad.study_abroad_request.each do |study_abroad_request|
      if study_abroad_request.no_answer?
        CommonMailer.reminder_three_days(study_abroad_request.user, study_abroad).deliver_now
      end
    end
  end
  Raven.capture_message(
    'Run three_days_before',
    level: :debug,
    extra: { study_abroads: study_abroads }
  )
  puts 'done.'
end

task seven_days_over_task: :environment do
  puts 'Run seven_days_over funtion for families...'
  study_abroads = StudyAbroad.all_seven_days_before_for_remind
  study_abroads.each do |study_abroad|
    # 参加希望者に対して再打診をするかどうかのメールを送信
    CommonMailer.readjustment_to_candidate(study_abroad).deliver_now
    CommonMailer.readjustment_to_manma(study_abroad).deliver_now
  end
  Raven.capture_message(
    'Run serven_days_over',
    level: :debug,
    extra: { study_abroads: study_abroads }
  )
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
