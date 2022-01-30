FROM ruby:3.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN apt-get update && apt-get install -y \
      libopus-dev \
      libsodium-dev \
      wget \
      xz-utils

WORKDIR /pomodoro-timer-bot

COPY . /pomodoro-timer-bot
RUN bundle install

CMD ["ruby", "bot.rb"]
