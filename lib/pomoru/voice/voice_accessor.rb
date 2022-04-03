# frozen_string_literal: true

class VoiceAccessor
  class << self
    def voice_client(session)
      voice_client = session.event.voice
      return unless voice_client && session.event.bot.connected?

      voice_client
    end

    def voice_channel(session)
      vc = voice_client(session)
      return unless vc

      vc.channel
    end

    def members_in_voice_channel(session)
      vc = voice_channel(session)
      return [] unless vc

      members = vc.users
      members.each do |member|
        members.delete(member) if member.current_bot?
      end
      members
    end
  end
end
