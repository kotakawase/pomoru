# frozen_string_literal: true

require_relative '../voice/voice_accessor'
require_relative '../message_builder'

class AutoShush
  attr_reader :all

  ALL = 'all'

  def initializa
    @all = false
  end

  def handle_all(session)
    author = session.event.author
    vc_name = VoiceAccessor.get_voice_channel(session).name

    if (author.defined_permission?(:mute_members) && author.defined_permission?(:deafen_members)) || author.defined_permission?(:adminstrator)
      if @all
        @all = false
        unshush(session)
        session.message.edit('', MessageBuilder.status_embed(session))
        session.event.send_message("#{vc_name}チャンネルのautoshushをOffにしました")
      else
        @all = true
        shush(session)
        session.message.edit('', MessageBuilder.status_embed(session))
        session.event.send_message("#{vc_name}チャンネルのautoshushをOnにしました")
      end
    else
      session.event.send_message('他のメンバーをミュートする権限がありません')
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
