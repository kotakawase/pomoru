# frozen_string_literal: true

SUMMARY = <<~TEXT
  ポモるで使えるコマンドヘルプ。

  必須パラメータは<>で囲まれ、オプションパラメーターは[]で囲まれます。
  たとえば「pmt!start」を実行してデフォルト値でポモドーロタイマーを開始したり、「pmt!start 30 10」を実行してポモドーロと休憩をカスタマイズしたりすることができます。

  もっと詳しいヘルプが知りたいときは、「pmt!help [command]」を実行することで確認することができるでしょう！
TEXT

START = <<~TEXT
  オプションのカスタム設定でポモドーロタイマーを開始します。
  各セッションは60分までパラメーターが有効です。
  （デフォルト値：25 5 15 4）

  pomodoro: ポモドーロの継続時間（分単位）
  short_break: 短い休憩の長さ（分単位）
  long_break: 長い休憩の長さ（分単位）
  intervals: 長い休憩をするまでにポモドーロする数
TEXT

EDIT = <<~TEXT
  ポモドーロタイマーを設定します。
  各セッションは60分までパラメーターが有効です。
  （デフォルト値：25 5 15 4）

  pomodoro: ポモドーロの継続時間（分単位）
  short_break: 短い休憩の長さ（分単位）
  long_break: 長い休憩の長さ（分単位）
  intervals: 長い休憩をするまでにポモドーロする数
TEXT

COUNTDOWN = <<~TEXT
  カウントダウンタイマーを開始します。
  タイマーは60分までパラメーターが有効です。

  オプションでカウントダウンしたい内容を入力することができ、入力しなかったときは"Countdown"がデフォルト値として実行されます。

  使用例：pmt!countdown 5 "宿題をやる！"
TEXT

REMIND = <<~TEXT
  リマインダーアラートをOnにします。
  （デフォルト値：25 5 15 4）
  リマインダーが必要ないセッションには0を渡すとこともできます。

  たとえば「pmt!remind」を実行してデフォルト値でリマインダーをOnにしたり、「pmt!remind 20 2」を実行してポモドーロと休憩のリマインダーを設定したりすることができます。
TEXT

AUTOSHUSH = <<~TEXT
  ポモドーロタイマーの途中に自動的にミュートされます。

  管理者権限を持つメンバーのみが、"all"パラメーターを使用してボイスチャンネルに参加している全員を強制的にミュートできます。
TEXT

COMMANDS = {
  'Control commands': {
    start: {
      command: 'start [pomodoro] [short_break] [long_break] [intervales]',
      use: START
    },
    pause: {
      command: 'pause',
      use: 'セッションの一時停止。'
    },
    resume: {
      command: 'resume',
      use: 'セッションの再開。'
    },
    restart: {
      command: 'restart',
      use: 'セッションのリスタート。'
    },
    skip: {
      command: 'skip',
      use: 'セッションのスキップ。'
    },
    end: {
      command: 'end',
      use: 'セッションの終了。'
    },
    edit: {
      command: 'edit <pomodoro> [short_break] [long_break] [interval]',
      use: EDIT
    }
  },
  'Info commands': {
    help: {
      command: 'help [command]',
      use: 'コマンドヘルプを表示します。'
    },
    status: {
      command: 'status',
      use: 'ポモドーロタイマーのステータスを取得します。'
    },
    stats: {
      command: 'stats',
      use: 'ポモドーロの統計を取得します。'
    },
    settings: {
      command: 'settings',
      use: 'ポモドーロタイマーの設定を取得します。'
    },
    servers: {
      command: 'servers',
      use: 'ポモるを使用しているサーバーの数を確認します。'
    }
  },
  'Other commands': {
    countdown: {
      command: 'countdown <duration> [task]',
      use: COUNTDOWN
    },
    remind: {
      command: 'remind [pomodoro] [short_break] [long_break]',
      use: REMIND
    },
    remind_off: {
      command: 'remind_off',
      use: 'リマインダーアラートをOffにします。'
    },
    volume: {
      command: 'volume [level]',
      use: 'アラートの音量を変更します。'
    }
  },
  'Subscription commands': {
    autoshush: {
      command: 'autoshush <all>',
      use: AUTOSHUSH
    }
  }
}.freeze
