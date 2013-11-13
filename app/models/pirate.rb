module Pirate
  class Client
    SEARCH_ENDPOINT = 'http://thepiratebay.sx/search/'
    SORT_ORDER = '/0/7/0'
    TRUSTWORTHY_THRESHOLD = 25

    def search_for_eligible_torrent(episode)
      search  = "#{SEARCH_ENDPOINT}#{episode.search_string}#{SORT_ORDER}"
      page    = get_with_logs(search)

      begin
        seeders = page.search('tr')[1].search('td')[2].text.to_i
        magnet  = page.links_with(href: /magnet/).first.href
      rescue NoMethodError => e
        Rails.logger.info("[Pirate::Client] No torrents found")
        return nil
      end

      if seeders > TRUSTWORTHY_THRESHOLD
        torrent = Torrent.new(magnet, episode.key)
        Rails.logger.info("[Pirate::Client] Found torrent: #{torrent.key} with #{seeders} seeds")
        torrent
      else
        nil
      end
    end

    private

    def get_with_logs(search)
      start_time = Time.now
      Rails.logger.info("[Pirate::Client] GET #{search}")

      begin
        page = mechanize.get(search)
      rescue Errno::ETIMEDOUT => e
        Rails.logger.info("[Pirate::Client] --> Connection timed out :(")
        return nil
      end

      Rails.logger.info("[Pirate::Client] --> Done in #{Time.now - start_time}s")
      page
    end

    def mechanize
      @mechanize ||= Mechanize.new
    end
  end

  class Torrent
    attr_reader :magnet, :key

    def initialize(magnet, key)
      @magnet = magnet
      @key    = key
    end
  end
end
