require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module TraktBot
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

module Keys
  class MissingKeys < StandardError; end

  KEYS = if Rails.env.production? 
    ENV
  else
    begin
      YAML.load_file('config/keys.yml')[Rails.env]
    rescue Errno::ENOENT
      raise MissingKeys.new('Need to specify keys in config/keys.yml')
    end
  end

  def self.method_missing(method)
    KEYS[method.upcase.to_s]
  end
end
