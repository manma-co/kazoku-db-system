desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Run reminder for families..."
  RequestLog.three_days_reminder
  puts "done."
end