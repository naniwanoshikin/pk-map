'use strict'; {
  // 住所検索 (home/_map_search)

  // 検索ボタン
  const go = document.querySelector('.codeaddress');
  // 検索結果 (map_search)
  const display = document.getElementById('display');

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
        display.textContent = "位置 " + ido_kedo
      } else {
        alert('該当する結果がありませんでした:' + status);
      }
    });
  })

}