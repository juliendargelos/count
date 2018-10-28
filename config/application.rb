require_relative 'boot'

require 'rails/all'
require __dir__ + '/../lib/core_ext'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Count
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.sass.preferred_syntax = :sass
    config.generators { |g| g.javascript_engine :js }

    config.action_mailer.default_url_options = { host: ENV['HOSTNAME'] }.compact.presence || { host: 'localhost', port: 3000 }
    config.assets.paths << Rails.root.join('node_modules')

    I18n.default_locale = :en
    I18n.available_locales = [:en, :fr]
  end
end
