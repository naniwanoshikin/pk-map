require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.time_zone = "Tokyo"
    # Active Recordのタイムゾーン
    # config.active_record.default_timezone = :local
    # config.eager_load_paths << Rails.root.join("extras")

    # localeを日本語にする 5
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

    # 認証トークンをremoteフォームに埋め込む 14
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
