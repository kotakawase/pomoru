FROM ruby:3.1

WORKDIR /pomodoro-timer-bot
COPY . /pomodoro-timer-bot

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN apt-get update && apt-get install -y \
      libopus-dev \
      libsodium-dev \
      wget \
      xz-utils
RUN wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz \
      && tar Jxvf ./ffmpeg-release-amd64-static.tar.xz \
      && cp ./ffmpeg*64-static/ffmpeg /usr/local/bin/
RUN bundle install

CMD ["bundle", "exec", "ruby", "bot.rb"]
