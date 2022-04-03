# frozen_string_literal: true

require_relative './session_activation'

class SessionFetcher < SessionActivation
  def self.current_session(event)
    session = SessionActivation::ACTIVE_SESSIONS[session_id_from(event)]
    event.send_message('アクティブなセッションはありません') unless session
    session
  end
end
