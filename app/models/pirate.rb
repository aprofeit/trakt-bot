module Pirate
  class Client
    SEARCH_ENDPOINT = 'http://thepiratebay.sx/search/'
    SORT_ORDER = '/0/7/0'
    TRUSTWORTHY_THRESHOLD = 25

    def search_for_eligible_torrent(episode)
      search  = "#{SEARCH_ENDPOINT}#{episode.search_string}#{SORT_ORDER}"
      page    = get_page_and_log_time(search)
      seeders = page.search('tr')[1].search('td')[2].text.to_i
      magnet  = page.links_with(href: /magnet/).first.href

      if seeders > TRUSTWORTHY_THRESHOLD
        Torrent.new(magnet, episode.key)
      else
        nil
      end
    end

    private

    def get_page_and_log_time(search)
      start_time = Time.now
      Rails.logger.info("GET #{search}")
      page = mechanize.get(search)
      Rails.logger.info("Done in #{Time.now - start_time}s\n")
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
