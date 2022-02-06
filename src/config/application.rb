require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # デフォルトのlocaleを日本語にする (5)
    config.i18n.default_locale = :ja

    # 今後自動でslimに変更 (6)
    # config.generators.template_engine = :slim
  end
end
