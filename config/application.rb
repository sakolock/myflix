require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

Sidekiq::Extensions.enable_delay!

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.initialize_on_precompile = false

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end

    config.autoload_paths << "#{Rails.root}/lib"
  end

  Raven.configure do |config|
    config.dsn = 'https://d216f3e2265e4bada156039a1170d48b:f6d490e877504e4db746322fc6bcfe8c@sentry.io/237130'
  end
end
