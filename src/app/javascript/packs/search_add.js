'use strict'; {
  // 住所入力 検索 (home/search_map)

  // 検索ボタン
  const go = document.querySelector('.codeaddress');

  go.addEventListener("click", function () {
    // 入力値
    let inputAddress = document.getElementById('address').value;

    // ジオコーディングをするためのリクエストを送信
    geocoder.geocode({ 'address': inputAddress }, (results, status) => {
      // 検索結果がヒットした時
      if (status == 'OK') {
        // 入力した値の緯度経度
        let ido_kedo = results[0].geometry.location
        // 地図の中心の位置を追加 + 表示?
        map.setCenter(ido_kedo);
        // ピンをさす
        marker = new google.maps.Marker({
          map: map,
          position: ido_kedo,
          // 色
          icon: {
            url: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png',
            // サイズ (縦, 横)
            scaledSize: new google.maps.Size(40, 40)
          }
        });
        let infowindow = new google.maps.InfoWindow();
        marker.addListener('click', function() {
          infowindow.setContent(
            // リンク + 画像
            '<div class="infowindow">'
            + `<img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${ido_kedo.lat()},${ido_kedo.lng()}&sensor=true&key=${ process.env.GOOGLE_MAP_API }' >`
            + '</div>'
          );
          infowindow.open(map, marker);
        });

        // display.textContent = "位置 " + ido_kedo // 不要かも
      } else {
        alert('該当する結果がありませんでした:' + status);
      }
    });
  })
}
