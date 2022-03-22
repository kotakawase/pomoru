# frozen_string_literal: true

class VoiceAccessor
  class << self
    def get_voice_client(session)
      session.event.voice
    end

    def get_voice_channel(session)
      vc = get_voice_client(session)
      return unless vc

      vc.channel
    end

    def get_members_in_voice_channel(session)
      vc = get_voice_channel(session)
      return [] unless vc

      members = vc.users
      members.each do |member|
        members.delete(member) if member.current_bot?
      end
      members
    end
  end
end
