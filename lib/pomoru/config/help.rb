# frozen_string_literal: true

SUMMARY = <<~TEXT
  pomoru is a Discord bot that allows you to use the Pomodoro technique on Discord.
  Set periods of focus to get work done and chat during the breaks.

  Required parameters are enclosed in <> and optional parameters are enclosed in [].
  For example, you can do "pmt!start" to start a pomodoro session with the default values or "pmt!start 30 10" to customize the pomodoro and short break durations!
TEXT

START = <<~TEXT
  Start pomodoro session with optional custom settings.

  pomodoro: duration of each pomodoro interval in minutes (default: 25 min)
  short_break: duration of short breaks in minutes (default: 5 min)
  long_break: duration of long breaks in minutes (default: 15 min)
  intervals: number of pomodoro intervals between each long break (default: 4)
TEXT

EDIT = <<~TEXT
  Continue session with new settings

  pomodoro: duration of each pomodoro interval in minutes (default: 25 min)
  short_break: duration of short breaks in minutes (default: 5 min)
  long_break: duration of long breaks in minutes (default: 15 min)
  intervals: number of pomodoro intervals between each long break (default: 4)
TEXT

COUNTDOWN = <<~TEXT
  Start a timer that updates in real time.

  Enclose title in " " if longer than one word (default: "Countdown").

  Example usage: pmt!countdown 5 "Finish homework!"
TEXT

REMIND = <<~TEXT
  Turn on reminder alerts (Defaults: 5, 1, 5)
  Pass in 0 if you do not want a reminder for the interval

  For example, you can run "pmt!remind" to turn on reminders by the default values or run "pmt!remind 20 2" to set pomodoro and short break reminders!
TEXT

AUTOSHUSH = <<~TEXT
  Get automatically deafened and muted during focus intervals.

  Only members with mute and deafen permissions can use the "all" parameter to autoshush everyone in the session voice channel.
TEXT

COMMANDS = {
  'Control commands': {
    start: {
      command: 'start [pomodoro] [short_break] [long_break] [intervales]',
      use: START
    },
    pause: {
      command: 'pause',
      use: 'Pause session'
    },
    resume: {
      command: 'resume',
      use: 'Resume session'
    },
    restart: {
      command: 'restart',
      use: 'Restart timer'
    },
    skip: {
      command: 'skip',
      use: 'Skip current interval and start the next pomodoro or break.'
    },
    end: {
      command: 'end',
      use: 'End session'
    },
    edit: {
      command: 'edit <pomodoro> [short_break] [long_break] [interval]',
      use: EDIT
    }
  },
  'Info commands': {
    help: {
      command: 'help [command]',
      use: 'Display help that summarizes how to use pomoru.'
    },
    status: {
      command: 'status',
      use: 'Get time remaining'
    },
    stats: {
      command: 'stats',
      use: 'Get session stats'
    },
    settings: {
      command: 'settings',
      use: 'Get session settings'
    },
    servers: {
      command: 'servers',
      use: 'See how many servers are using pomodro'
    }
  },
  'Other commands': {
    countdown: {
      command: 'countdown <duration> [title]',
      use: COUNTDOWN
    },
    remind: {
      command: 'remind [pomodoro] [short_break] [long_break]',
      use: REMIND
    },
    remind_off: {
      command: 'remind_off',
      use: 'Turn off reminders'
    },
    volume: {
      command: 'volume [level]',
      use: 'Change thevolume of alerts'
    }
  },
  'Subscription commands': {
    autoshush: {
      command: 'autoshush [all]',
      use: AUTOSHUSH
    }
  }
}.freeze
