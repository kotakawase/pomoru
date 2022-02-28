# frozen_string_literal: true

class SessionManeger
  ACTIVE_SESSIONS = {}.freeze

  class << self
    def activate(event, session)
      ACTIVE_SESSIONS[session_id_from(event)] = session
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
