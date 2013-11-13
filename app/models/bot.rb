class Bot
  TODAYS_CALENDAR_ENDPOINT = "http://api.trakt.tv/user/calendar/shows.json/#{Keys.trakt_api_key}/aprofeit/today/1"

  def queue_downloads
    pending_episodes = trakt.pending_episodes

    pending_episodes.each do |pending_episode|
      if episode_torrent = pirate_bay.search_for_eligible_torrent(pending_episode.search_string)
        transmission.add_torrent(episode_torrent.magnet)
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
