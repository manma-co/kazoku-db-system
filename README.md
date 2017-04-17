# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version  
ruby 2.4.0p0 (2016-12-24 revision 57164)

* Rails version  
Rails 5.0.2

* Configuration
Need to have secret.yml

* Database creation
Use sqlite3 for development environment

Run those command to run application
```
$ bundle install
$ rails db:migrate
$ rails db:seed
$ rails s
```

##### Try those code to recreate database based on migration files
```
bundle exec rake db:drop db:create db:migrate db:seed
```
