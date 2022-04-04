# frozen_string_literal: true

class SessionActivation
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

    def session_id_from(event)
      event.server.id.to_s + event.channel.id.to_s
    end
  end
end
