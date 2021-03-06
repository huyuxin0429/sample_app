require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)



module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths << Rails.root.join("lib/**/")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = "/cable"
  end
end
