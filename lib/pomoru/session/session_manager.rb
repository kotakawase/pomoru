# frozen_string_literal: true

require_relative '../voice/voice_accessor'

class SessionManager
  # rubocop:disable Style/MutableConstant
  ACTIVE_SESSIONS = {}
  # rubocop:enable Style/MutableConstant

  class << self
    def activate(session)
      ACTIVE_SESSIONS[session_id_from(session.event)] = session
    end

    def deactivate(session)
      ACTIVE_SESSIONS.delete(session_id_from(session.event))
    end

    def get_session(event)
      session = ACTIVE_SESSIONS[session_id_from(event)]
      event.send_message('アクティブなセッションはありません') unless session
      session
    end

    def session_id_from(event)
      event.server.id.to_s + event.channel.id.to_s
    end

    def kill_if_thread_exists(session)
      return unless !VoiceAccessor.get_voice_channel(session) || VoiceAccessor.get_members_in_voice_channel(session).length.zero?
    end
  end
end
