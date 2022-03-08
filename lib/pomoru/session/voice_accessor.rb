module VoiceAccessor
  module_function

  def get_voice_client(session)
    voice_client = session.event.voice
    return voice_client
  end

  def get_voice_channel(session)
    vc = get_voice_client(session)
    unless vc
      return
    end
    return vc.channel
  end

  def get_members_in_voice_channel(session)
    vc = get_voice_channel(session)
    unless vc
      return Array.new
    end

    members = vc.users
    members.each do |member|
      if member.current_bot?
        members.delete(member)
      end
    end
    return members
  end
end
