module Trakt
  class Client
    TODAYS_CALENDAR_ENDPOINT = "http://api.trakt.tv/user/calendar/shows.json/#{Keys.trakt_api_key}/aprofeit/20131110/1"

    def pending_episodes
      calendar = HTTParty.get(TODAYS_CALENDAR_ENDPOINT).parsed_response.first

      return nil if calendar.nil?

      pending_episodes = calendar['episodes'].select do |episode|
        episode = Episode.new(episode)
        episode.aired? && !episode.downloaded?
      end

      pending_episodes.map { |e| Episode.new(e) }
    end
  end

  class Episode
    def initialize(trakt_episode)
      @title    = trakt_episode['show']['title']
      @runtime  = trakt_episode['show']['runtime'].minutes
      @season   = trakt_episode['episode']['season']
      @number   = trakt_episode['episode']['number']
      @aired_at = Time.at(trakt_episode['episode']['first_aired_utc'])  
    end

    def aired?
      (Time.now - @aired_at) > @runtime
    end

    def downloaded?
      transmission.downloaded?(key)
    end

    def key
      "#{@title} S#{'%02d' % @season}E#{'%02d' % @number}"
    end

    def search_string
      URI.encode "#{@title} S#{'%02d' % @season}E#{'%02d' % @number}"
    end

    private

    def transmission
      @transmission ||= Transmission::Client.new
    end
  end
end
