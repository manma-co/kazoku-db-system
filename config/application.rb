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
  config.dsn = 'https://67dc2b7e66c845899ca74441e3ef3bf6:54bff7c7d3554cf1b48381e7d974b623@sentry.io/2471304'
  config.environments = %w[production]
end
