'use strict'; {
  // 住所検索 (shared/feed)

  let post_header;
  // 検索結果 (posts/post) 6 2ページ目も取れないか？
  for(let i = 0; i < gon.feed.length; i++) {
    post_header = document.getElementById(`post_header${gon.posts.length-i}`);

    post_header.addEventListener("click", function () {
      geocoder.geocode({ 'address': post_header.textContent }, (results, status) => {
        if (status == 'OK') {
          let ido_kedo = results[0].geometry.location
          map.setCenter(ido_kedo);
          // ピン
          // 最後の住所しか取れていない...
          // 住所という値しか取っていないから 緯度経度が最後だ..
          let marker = new google.maps.Marker({
            map: map,
            position: ido_kedo,
            icon: {
              url: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png',
              scaledSize: new google.maps.Size(40, 40)
            }
          });
          display.textContent = "位置:" + ido_kedo
        } else {
          alert('該当する結果がありませんでした:' + status);
        }
      });
    })
  }

}
