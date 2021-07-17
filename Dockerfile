FROM ruby:2.5.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /app
# Use those code if you do not use docker compose,
# to create multiple container like as database, radis, and so on.
CMD ["rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000