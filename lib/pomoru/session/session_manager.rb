# frozen_string_literal: true

class SessionManager
  # rubocop:disable Style/MutableConstant
  ACTIVE_SESSIONS = {}
  # rubocop:enable Style/MutableConstant

  class << self
    def activate(event, session)
      ACTIVE_SESSIONS[session_id_from(event)] = session
    end

    def deactivate(event, session)
      ACTIVE_SESSIONS.delete(session_id_from(event))
    end

    def get_session(event)
      session = ACTIVE_SESSIONS[session_id_from(event)]
      session || event.send_message('No active session.')
    end

    def session_id_from(event)
      event.server.id.to_s + event.channel.id.to_s
    end
  end
end
