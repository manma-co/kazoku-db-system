# KAZOKU DB SYSTEM

[![CircleCI](https://circleci.com/gh/manma-co/kazoku-db-system.svg?style=svg)](https://circleci.com/gh/manma-co/kazoku-db-system)
[![codecov](https://codecov.io/gh/manma-co/kazoku-db-system/branch/master/graph/badge.svg)](https://codecov.io/gh/manma-co/kazoku-db-system)

## ENVIRONMENT

- Ruby version: 2.5.5
- Rails version: 5.0.7.2
- Configuration: Need to have secret.yml
- Database creation: Use sqlite3 for development environment

Run those command to run application

```bash
bundle install
rails db:migrate
rails db:seed
rails s
```

## Test

```bash
bundle exec rspec
bundle exec rspec spec/controllers/
bundle exec rspec spec/models/
bundle exec rspec spec/requests/
```

### Try those code to recreate database based on migration files

```bash
bundle exec rake db:drop db:create db:migrate db:seed
```

## Deploy

You need Heroku account. Please ask maintaineer about account.

※ if you execute command below, you need to prepare for heroku

```bash
git push heroku release:master
```

when merge to master, deploying automatically (it is be configured on Heroku).

## Generate ER

```bash
bundle exec erd --inheritance --direct --attributes=foreign_keys,content --filetype=dot
dot -Tpng erd.dot -o erd.png
```

## Lint

```bash
rubocop -a
```
