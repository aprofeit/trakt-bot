module Transmission
  class Client
    def add_torrent(torrent)
      response = HTTParty.post(Keys.transmission_endpoint,
        body: {
          'method' => 'torrent-add',
          'arguments' => {
            'filename' => torrent.magnet
          }
        }.to_json,
        headers: {
          'x-transmission-session-id' => session_id
        }
      )

      if response['result'] == 'success'
        mark_as_downloaded(torrent)
        true
      else
        false
      end
    end

    def downloaded?(key)
      !!redis.get(key)
    end

    private

    def mark_as_downloaded(torrent)
      redis.set(torrent.key, 'YES')

      NotificationRecipient.find_each do |recipient|
        twilio.account.sms.messages.create({
          from: Keys.twilio_number,
          to: recipient.phone,
          body: "Started downloading #{torrent.key}"
        })
      end
    end

    def redis
      Redis.current
    end

    def session_id
      @session_id ||= HTTParty.post(Keys.transmission_endpoint).headers['x-transmission-session-id']
    end

    def twilio
      @twilio ||= Twilio::REST::Client.new(Keys.twilio_account_sid, Keys.twilio_auth_token)
    end
  end
end
