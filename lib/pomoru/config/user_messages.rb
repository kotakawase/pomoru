# frozen_string_literal: true

require_relative 'config'

GREETINGS = [
  'こんにちは！今日も集中できるといいですね',
  '集中する時間を決めてみんなでワイワイ作業しましょう！',
  '生産性を高めていきましょう！',
  'お久しぶりです！さくポモしていきませんか',
  'ポモるはあなたの作業を見守ることができます！',
  'ちょっとそこ！集中できてますか！',
  'ポモドーロテクニックは25分間の作業と5分間の休憩をはさむ時間管理術です！',
  'ポモるの名前の由来は"メモる"、"ググる"といった略され言葉に影響されてつけられました'
].freeze

MISSING_ARG_ERR = '最低でも1つパラメータを入力する必要があります'
AUTOSHUSH_ARG_ERR = '"me"もしくは"all"を入力してください'
ACTIVE_SESSION_EXISTS_ERR = '既にアクティブなセッションがあります'
NUM_OUTSIDE_ONE_AND_MAX_INTERVAL_ERR = "1〜#{MAX_INTERVAL_MINUTES}分までのパラメータを入力してください".freeze
COUNTDOWN_RUNNING = 'カウントダウンタイマーが動いています'
