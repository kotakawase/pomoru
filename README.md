# ポモる [![Lint](https://github.com/kotakawase/pomoru/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/kotakawase/pomoru/actions/workflows/lint.yml) [![Test](https://github.com/kotakawase/pomoru/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/kotakawase/pomoru/actions/workflows/test.yml) [![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

あなたのDiscordサーバーへ招待するには、<a href="https://discord.com/api/oauth2/authorize?client_id=928807564567797821&permissions=15739904&scope=bot">ここ</a>をクリックしてください！

![スクリーンショット 2022-03-29 0 01 23](https://user-images.githubusercontent.com/74460623/160427795-1e04fcdb-10c4-4f23-8051-a1f0f469947f.png)

## ポモるとは？
ポモるは、Discord上で複数人がポモドーロテクニックをできない問題を解決したいDiscordで勉強する人向けのDiscord Botです。ユーザーはDiscord上でポモドーロテクニックを使うことができ、キッチンタイマーを使うとのとは違って、複数人で同時に使える環境が備わっていることが特徴です。

## その他の特徴
- ポモドーロと休憩のスタート時にアラートを再生
- ポモドーロと休憩のスタート時にテキストを発言
- ポモドーロ、休憩、インターバルの設定
- ポモドーロと休憩の一時停止
- ポモドーロと休憩のリセット
- ポモドーロと休憩のスキップ
- カウントダウンタイマーの設定
- リマインダーアラートの設定
- アラートの音量を設定
- ポモドーロタイマーのステータスを取得
- ポモドーロの統計を取得
- ポモドーロタイマーの設定を取得
- メンバーをミュート
- コマンドプレフィックスは「pmt!」

## コマンド
必須パラメータは`<>`で囲まれ、オプションパラメーターは`[]`で囲まれます。\
たとえば「pmt!start」を実行してデフォルト値でポモドーロタイマーを開始したり、「pmt!start 30 10」を実行してポモドーロと休憩をカスタマイズしたりすることができます。

### Control
> **start  \[pomodoro] \[short_break] \[long_break] \[intervales]**\
> ポモドーロタイマーを開始します。\
> 各セッションは60分までパラメーターが有効です。(デフォルト値：25 5 15 4)

> **pause**\
> セッションの一時停止。

> **resume**\
> セッションの再開。

> **restart**\
> セッションのリスタート。

> **skip**\
> セッションのスキップ。

> **end**\
> セッションの終了。

> **edit \<pomodoro> \[short_break] \[long_break] \[interval]**\
> ポモドーロタイマーを設定します。

### Info
> **help \[command]**\
> コマンドヘルプを表示します。

> **status**\
> ポモドーロタイマーのステータスを取得します。

> **stats**\
> ポモドーロの統計を取得します。

> **settings**\
> ポモドーロタイマーの設定を取得します。

> **servers**\
> ポモるを使用しているサーバーの数を確認します。

### Other
> **countdown \<duration> \[task]**\
> カウントダウンタイマーを開始します。

> **remind \[pomodoro] \[short_break] \[long_break]**\
> リマインダーアラートを設定します。(デフォルト値：5 1 5)\
> 各セッションのタイマー以下であればオプションパラメータを設定することができます。

> **remind_off**\
> リマインダーアラートをOffにします。

> **volume \[level]**\
> アラートの音量を変更します。(デフォルト値：1)\
> 音量は0..2まで変更可能です。

### Subscription
> **autoshush \<all>**\
> ユーザーを全員ミュートします。\
> 実行するには管理者権限が必要です。

## 使用技術
- Ruby 3.1.0
- discordrb 3.4.1
- Docker

## セットアップ
Botの作成
1. Discordの[DEVELOPER PORTAL](https://discord.com/developers/applications)へアクセス
2. New Applicationを押し、任意のアプリケーション名を入力してCreate
3. BotのTOKENとCLIENT IDを控えておく
4. OAuth2 > URL Generatorを押し、SCOPESの「bot」にチェックを入れる
5. BOT PERMISSIONSにはそれぞれ以下の権限にチェックを入れる
  - GENERAL PREMISSIONS
    - [x] Read Messages/View Channles
  - TEXT PREMISSIONS
    - [x] Send Messages
    - [x] Manage Messages
  - VOICE PERMISSIONS
    - [x] Connect
    - [x] Speak
    - [x] Mute Members
    - [x] Deafen Members

6.　発行されたURLをコピーしてBotをサーバーへ招待する

Docker imageを作成もしくは[dockerhub](https://hub.docker.com/r/kotakawase/pomoru)からpullします
```bash
# Docker image
$ git clone https://github.com/kotakawase/pomoru.git
$ cd pomoru
$ docker build -t kotakawase/pomoru:main .

# dockerhubからpull
$ docker pull kotakawase/pomoru:main
```

Docker imageが作成されていることを確認
```bash
$ docker images
REPOSITORY                 TAG       IMAGE ID       CREATED          SIZE
kotakawase/pomoru          main      XXXXXXXXXXXX   X hours ago      XXXGB
```

Docker起動に必要な環境変数を設定

| 環境変数名 | 説明 |
| --- | --- |
| TOKEN | BotのTOKEN |
| CLIENT_ID | BotのCLIENT ID |
| PREFIX | コマンドプレフィックス |

```bash
$ touch ~/.env
```
```env
TOKEN=YOUR_DISCORD_ACCESS_TOKEN
CLIENT_ID=YOUR_DISCORD_CLIENT_ID
PREFIX=COMMAND_PREFIX_TO_USE
```

## 起動
Dockerを起動
```bash
$ docker run --env-file ~/.env kotakawase/pomoru:main
```

<details><summary>Dockerを使用しずに起動する場合はこちらをご参照ください</summary><div>

リポジトリをCloneしてフォルダに移動
```bash
$ git clone https://github.com/kotakawase/pomoru.git
$ cd pomoru
```

discordrbで音声機能を扱うために必要なパッケージをローカル環境にインストールします。\
参考： [discordrb - Dependencies Voice dependencies](https://github.com/shardlab/discordrb#voice-dependencies)

```bash
$ brew install libsodium
$ brew install opus
$ brew install ffmpeg
```

Bot起動に必要な環境変数を設定

| 環境変数名 | 説明 |
| --- | --- |
| TOKEN | BotのTOKEN |
| CLIENT_ID | BotのCLIENT ID |
| PREFIX | コマンドプレフィックス |

```bash
$ touch .env
```
```env
TOKEN=YOUR_DISCORD_ACCESS_TOKEN
CLIENT_ID=YOUR_DISCORD_CLIENT_ID
PREFIX=COMMAND_PREFIX_TO_USE
```

gemのインストール
```bash
$ bundle install
```

Botを起動
```bash
$ bin/run
or
$ bundle exec ruby run.rb
```

---

</div></details>

## Lint & Test

| コマンド | 説明 |
| --- | --- |
| `bin/lint` | Rubocopを実行 |
| `bin/test` | Minitestのテストを実行 |

## スクリーンショット

![スクリーンショット 2022-04-04 12 34 01](https://user-images.githubusercontent.com/74460623/161469535-e9b4f858-4d2b-4b78-9e4c-16b49a59f074.png)

![スクリーンショット 2022-04-04 12 25 47](https://user-images.githubusercontent.com/74460623/161469266-2377be82-bf0c-4a0a-aa03-1f516ec2aad3.png)

![スクリーンショット 2022-04-04 12 26 05](https://user-images.githubusercontent.com/74460623/161469433-bdaf9cc4-8a6e-4194-a6a8-87bd0306d533.png)

## デモ

![https://gyazo.com/a4a46a2bc6ba099e32d695095e3585d2](https://gyazo.com/a4a46a2bc6ba099e32d695095e3585d2.gif)

## Herokuへのデプロイ
リポジトリをCloneしてフォルダに移動
```bash
$ git clone https://github.com/kotakawase/pomoru.git
$ cd pomoru
```

Heroku上に任意のアプリケーションを作成
```
$ heroku create APPLICATTION_NAME
```

Herokuデプロイに必要な環境変数を設定
```
$ heroku config:set TOKEN=YOUR_DISCORD_ACCESS_TOKEN CLIENT_ID=YOUR_DISCORD_CLIENT_ID PREFIX=COMMAND_PREFIX_TO_USE
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

![スクリーンショット 2022-03-28 15 47 25](https://user-images.githubusercontent.com/74460623/160341565-101c9c8e-43ba-47de-a552-6a0a66a3c10f.png)

## 謝辞
このBotは既にサービスとして存在する[Pomomo](https://www.pomomo.bot/)に影響を受けて作りました。

ありがとうございます！

## ライセンス
このBotは[MIT License](https://opensource.org/licenses/MIT)の条件下でオープンソースとして利用できます。
