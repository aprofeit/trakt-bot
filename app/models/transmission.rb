module Transmission
  class Client
    def add_torrent(magnet)
      response = HTTParty.post(Keys.transmission_endpoint,
        body: {
          'method' => 'torrent-add',
          'arguments' => {
            'download-dir' => Keys.download_dir,
            'filename'     => magnet
          }
        }.to_json,
        headers: {
          'x-transmission-session-id' => session_id
        }
      )

      response.code
    end

    def downloaded?(key)

    end

    private

    def session_id
      @session_id ||= HTTParty.post(Keys.transmission_endpoint).headers['x-transmission-session-id']
    end
  end
end
