module Trakt
  class Client
    def pending_episodes(date)
      calendar = get_with_logs(date).parsed_response.first

      return [] if calendar.nil?

      pending_episodes = calendar['episodes'].select do |episode|
        episode = Episode.new(episode)
        context_time = date == 'today' ? Time.now : (Date.parse(date) + 1.day).end_of_day
        episode.aired?(context_time) && !episode.downloaded?
      end

      pending_episodes.map { |e| Episode.new(e) }
    end

    private

    def get_with_logs(date)
      start_time = Time.now
      Rails.logger.info("GET #{calendar_endpoint(date)}")
      response = HTTParty.get(calendar_endpoint(date))
      Rails.logger.info("--> Done in #{Time.now - start_time}s")
      response
    end

    def calendar_endpoint(date)
      "http://api.trakt.tv/user/calendar/shows.json/#{Keys.trakt_api_key}/aprofeit/#{date}/1"
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

    def aired?(context_time)
      (context_time - @aired_at) > @runtime
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
