require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ManmaSystem
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    config.active_record.time_zone_aware_types = [:datetime]
  end
end

# Sentry io: error reporting setting.
# TO see more info or additional more options.
# See here: https://docs.sentry.io/clients/ruby/config/
Raven.configure do |config|
  config.dsn = 'https://442c94c03cf4479abef3c993a1e3a652:cc29f160535647cba9ec43064f0750c5@sentry.io/197206'
  config.environments = %w[ production ]
end