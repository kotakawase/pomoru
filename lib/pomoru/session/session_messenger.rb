# frozen_string_literal: true

require_relative '../config/user_messages'
require_relative '../message_builder'

class SessionMessenger
  class << self
    def send_start_msg(session)
      embed = MessageBuilder.status_embed(session)
      session.message = session.event.send_embed(GREETINGS.sample.to_s, embed)
      session.event.send_embed('', MessageBuilder.settings_embed(session))
      session.message.pin
    end

    def send_edit_msg(session)
      session.event.send_embed('新しい設定でポモドーロタイマーを継続します',
                               MessageBuilder.settings_embed(session))
    end

    def send_countdown_msg(session, title)
      embed = MessageBuilder.countdown_embed(session, title)
      session.message = session.event.send_embed('', embed)
      session.message.pin
    end

    def send_remind_msg(session)
      reminders = session.reminder
      if reminders.pomodoro == 'None' && reminders.short_break == 'None' && reminders.long_break == 'None'
        session.reminder.running = false
        session.message.edit('', MessageBuilder.status_embed(session))
        session.event.send_message('すべてのリマインダーは0です')
      else
        session.event.send_embed('リマインダーアラートがOnになりました', MessageBuilder.reminders_embed(session))
      end
    end
  end
end
