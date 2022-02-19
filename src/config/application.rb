require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # localeを日本語にする (5)
    config.i18n.default_locale = :ja
    # ファイル生成 7
    config.generators do |g|
      # rspecにする
      g.test_framework :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: false
      # g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
