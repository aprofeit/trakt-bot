module Transmission
  class Client
    def add_torrent(torrent)
      response = HTTParty.post(Keys.transmission_endpoint,
        body: {
          'method' => 'torrent-add',
          'arguments' => {
            'download-dir' => Keys.download_dir,
            'filename'     => torrent.magnet
          }
        }.to_json,
        headers: {
          'x-transmission-session-id' => session_id
        }
      )

      if response['result'] == 'success'
        mark_as_downloaded(torrent.key)
        true
      else
        false
      end
    end

    def downloaded?(key)
      !!redis.get(key)
    end

    private

    def mark_as_downloaded(key)
      redis.set(key, 'YES')
    end

    def redis
      Redis.current
    end

    def session_id
      @session_id ||= HTTParty.post(Keys.transmission_endpoint).headers['x-transmission-session-id']
    end
  end
end
