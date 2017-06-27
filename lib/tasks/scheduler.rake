# To go setting page for scheduler, run `heroku addons:open scheduler`
# Refer document: https://devcenter.heroku.com/articles/scheduler
desc "This task is called by the Heroku scheduler add-on"
task :three_days_reminder_task => :environment do
  puts "Run three_days_reminder funtion for families..."
  RequestLog.three_days_reminder
  puts "done."
end

task :ten_days_over_task => :environment do
  puts "Run ten_days_over funtion for families..."
  RequestLog.ten_days_over
  puts "done."
end