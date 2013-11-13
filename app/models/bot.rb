class Bot
  def queue_downloads(date = 'today')
    pending_episodes = trakt.pending_episodes(date)

    pending_episodes.each do |pending_episode|
      if episode_torrent = pirate_bay.search_for_eligible_torrent(pending_episode)
        transmission.add_torrent(episode_torrent)
      end
    end
  end

  private

  def trakt
    @trakt ||= Trakt::Client.new
  end

  def transmission
    @transmission ||= Transmission::Client.new
  end

  def pirate_bay
    @pirate_bay ||= Pirate::Client.new
  end
end
