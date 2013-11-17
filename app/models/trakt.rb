module Trakt
  class Client
    def pending_episodes(date)
      calendar = get_with_logs(date).parsed_response.first

      return [] if calendar.nil?

      pending_episodes = calendar['episodes'].select do |episode|
        episode = Episode.new(episode)
        override_aired = true if date != 'today'
        episode.aired?(override_aired) && !episode.downloaded?
      end

      pending_episodes.map { |e| Episode.new(e) }
    end

    def episodes(date = 'today')
      calendar = get_with_logs(date).parsed_response.first

      return [] if calendar.nil?

      calendar['episodes'].map { |e| Episode.new(e) }
    end

    private

    def get_with_logs(date)
      start_time = Time.now
      Rails.logger.info("[Trakt::Client] GET #{calendar_endpoint(date)}")
      response = HTTParty.get(calendar_endpoint(date))
      Rails.logger.info("[Trakt::Client] --> Done in #{Time.now - start_time}s")
      response
    end

    def calendar_endpoint(date)
      "http://api.trakt.tv/user/calendar/shows.json/#{Keys.trakt_api_key}/aprofeit/#{date}/1"
    end
  end

  class Episode
    attr_reader :title, :overview, :aired_at, :number, :season

    def initialize(trakt_episode)
      @title    = trakt_episode['show']['title']
      @runtime  = trakt_episode['show']['runtime'].minutes
      @season   = trakt_episode['episode']['season']
      @number   = trakt_episode['episode']['number']
      @overview = trakt_episode['episode']['overview']
      @aired_at = Time.at(trakt_episode['episode']['first_aired_utc'])
    end

    def aired?(override = nil)
      if override
        true
      else
        (Time.now - @aired_at) > @runtime
      end
    end

    def downloaded?
      transmission.downloaded?(key)
    end

    def key
      "#{@title.delete("'")} S#{'%02d' % @season}E#{'%02d' % @number}"
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
