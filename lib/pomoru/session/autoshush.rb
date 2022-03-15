# frozen_string_literal: true

require_relative './voice_accessor'

class AutoShush
  attr_reader :all

  ALL = 'all'
  ME = 'me'

  def initializa
    @all = false
  end

  def handle_all(session)
    author = session.event.author
    vc_name = VoiceAccessor.get_voice_channel(session).name

    # permission?でも検討する
    # meは別途対応
    if (author.defined_permission?(:mute_members) && author.defined_permission?(:deafen_members)) || author.defined_permission?(:adminstrator)
      if @all
        @all = false
        unshush(session)
        session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
        session.event.send_message("Auto-shush has been turned off for the #{vc_name} channel.")
      else
        @all = true
        shush(session)
        session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
        session.event.send_message("Auto-shush has been turned on for the #{vc_name} channel.")
      end
    else
      session.event.send_message('You do not have permission to mute and deafen other members.')
      nil
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
