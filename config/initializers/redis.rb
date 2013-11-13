uri                     = URI.parse(Settings::KEYS['REDISTOGO_URL'])
redis_params            = { host: uri.host, port: uri.port }
redis_params[:password] = uri.password if Rails.env.production?

Redis.current = Redis.new(redis_params)
