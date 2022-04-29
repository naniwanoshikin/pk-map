require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Webアプリのブラウザ操作をシミュレーション (5.3)
require 'capybara/rspec'

# spec/support/ およびそのサブディレクトリにある、カスタムマッチャーやマクロなどを含むサポート用 Ruby ファイルが必要です。spec/**/*_spec.rb` にマッチするファイルは、デフォルトで spec ファイルとして実行されます。つまり、spec/supportにある_spec.rbで終わるファイルは、specとして要求され、実行されるので、specが2度実行されることになります。このグロブにマッチするファイル名を_spec.rbで終わらないようにすることをお勧めします。このパターンはコマンドラインの--patternオプション、または~/.rspec、.rspec、`.rspec-local`で設定することができます。

# 便宜上、以下のような行程を設けています。サポートディレクトリにあるすべてのファイルを自動で要求するため、起動時間が長くなるという欠点があります。代わりに、個々の `*_spec.rb` ファイルで、必要なサポートファイルのみを手動で要求することもできます。

# support/配下のファイルを読み込む (5)
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# 保留中のマイグレーションをチェックし、テスト実行前に適用します。
# ActiveRecordを使用しない場合は、これらの行を削除してください。
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # 省略記法を使う create(:user)
  config.include FactoryBot::Syntax::Methods # 5
  # ヘルパーメソッドを使用
  config.include TestHelper
  config.include ApplicationHelper
  config.include SystemHelper # 10

  config.use_transactional_fixtures = true


  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

end
