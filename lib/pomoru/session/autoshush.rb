require_relative './voice_accessor'

class AutoShush
  ALL = "all"
  ME = "me"

  def initializa
    @all = false
  end

  def handle_all(session)
    author = session.event.author
    vc_name = VoiceAccessor.get_voice_channel(session)

    # permission?でも検討する
    # meは別途対応
    unless author.defined_permission?(:mute_members) && author.defined_permission?(:deafen_members) || author.defined_permission?(:adminstrator)
      session.event.send_message('You do not have permission to mute and deafen other members.')
      return
    else
      if @all
        @all = false
        unshush(session)
        session.event.send_message('Auto-shush has been turned off for the channel.')
      else
        @all = true
        shush(session)
        session.event.send_message('Auto-shush has been turned on for the channel.')
      end
    end
  end

  private

  def shush(session)
    vc_members = VoiceAccessor.get_members_in_voice_channel(session)
    vc_members.each do |member|
      member.server_mute
      member.server_deafen
    end
  end

  def unshush(session)
    vc_members = VoiceAccessor.get_members_in_voice_channel(session)
    vc_members.each do |member|
      member.server_unmute
      member.server_undeafen
    end
  end
end
