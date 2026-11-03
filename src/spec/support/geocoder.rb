# spec/rails_helper.rb (または spec/support/geocoder.rb)

RSpec.configure do |config|
  config.before(:suite) do
    # Geocoderをテストモードにする
    Geocoder.configure(lookup: :test, ip_lookup: :test)

    # 「梅田」や「東京駅」などの住所が指定されたときに返す擬似データを登録しておく
    Geocoder::Lookup::Test.add_stub(
      "梅田", [
        {
          'coordinates'  => [34.7024, 135.4959], # 緯度, 経度
          'address'      => '大阪府大阪市北区梅田',
          'state'        => '大阪府',
          'country'      => '日本'
        }
      ]
    )
  end
end
