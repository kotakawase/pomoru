# pomoru
## About
`pomoru`はDiscord上でポモドーロテクニックを使うことができるDiscord botです。

## Features
- ポモドーロスタート時にアラートを再生。
- ポモドーロスタート時にテキストを発言。
- ポモドーロ、休憩、インターバルの設定。
- ポモドーロと休憩の一時停止。
- ポモドーロと休憩のリセット。
- ポモドーロと休憩のスキップ。
- カウントダウンタイマーの設定。
- リマインダーアラートの設定。
- アラートの音量を設定。
- ポモドーロのステータスを取得。
- ポモドーロの統計を取得。
- ポモドーロの設定を取得。
- メンバーをミュート。
- prefixは`pmt!`。

## Demo

## Commands

## Setup
＊ Dockerのインストールが必要です。

Docker imageを作成もしくはdockerhubからpullします（注：まだ未公開）
```bash
# Docker image
$ git clone https://github.com/kotakawase/pomoru.git
$ cd pomoru
$ docker build -t pomoru .

# dockerhubからpull
$ docker pull pomoru
```

Docker imageが作成されていることを確認
```
$ docker images
REPOSITORY                 TAG       IMAGE ID       CREATED        SIZE
pomoru                     latest    XXXXXXXXXXXX   X weeks ago    XXXMB
```

環境変数を設定
```bash
$ touch ~/.env
```
```env
TOKEN=YOUR_DISCORD_ACCESS_TOKEN
CLIENT_ID=YOUR_DISCORD_CLIENT_ID
PREFIX=pmt!
```

## Run
コンテナを起動
```bash
$ docker run --env-file ~/.env pomoru
```

## Deploying to Heroku
＊ Heroku CLIのインストールが必要です。

リポジトリをCloneしてフォルダに移動
```bash
$ git clone https://github.com/kotakawase/pomoru.git
$ cd pomoru
```
Heroku上に任意のアプリケーションを作成
```
$ heroku create APPLICATTION_NAME
```
環境変数を設定
```
$ heroku config:set TOKEN=YOUR_DISCORD_ACCESS_TOKEN CLIENT_ID=YOUR_DISCORD_CLIENT_ID PREFIX=pmt!
```
アプリケーションのstackをcontainerに設定
```
$ heroku stack:set container
```
リポジトリをHerokuにpush
```
$ git push heroku main
```
web dynoをアクティブにする
```
$ heroku ps:scale worker=1
```

## License
pomoru is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
