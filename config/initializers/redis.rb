if Keys.redistogo_url
  uri                     = URI.parse(Keys.redistogo_url)
  redis_params            = { host: uri.host, port: uri.port }
  redis_params[:password] = uri.password if Rails.env.production?

  Redis.current = Redis.new(redis_params)
end
