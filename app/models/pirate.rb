module Pirate
  class Client
    SEARCH_ENDPOINT = 'http://thepiratebay.sx/search/'
    SORT_ORDER = '/0/7/0'
    TRUSTWORTHY_THRESHOLD = 50

    def search_for_eligible_torrent(query)
      page = mechanize.get("#{SEARCH_ENDPOINT}#{query}#{SORT_ORDER}")
      seeders = page.search('tr')[1].search('td')[2].text.to_i
      magnet  = page.links_with(href: /magnet/).first.href

      if seeders > TRUSTWORTHY_THRESHOLD
        Torrent.new(magnet)
      else
        nil
      end
    end

    private

    def mechanize
      @mechanize ||= Mechanize.new
    end
  end

  class Torrent
    attr_reader :magnet

    def initialize(magnet)
      @magnet = magnet
    end
  end
end
