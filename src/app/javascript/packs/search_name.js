'use strict'; {
  // エラーのため未使用
  // 住所検索 (shared/feed)

  let post_header;
  // 検索結果 (posts/post) 6 2ページ目が取れない...
  for(let i = 0; i < gon.feed.length; i++) {
    post_header = document.getElementById(`post_header${gon.posts.length-i}`);

    // ページめくるとエラー: Cannot read properties of null (reading 'addEventListener')
    post_header.addEventListener("click", function () {
      geocoder.geocode({ 'address': post_header.textContent }, (results, status) => {
        if (status == 'OK') {
          let ido_kedo = results[0].geometry.location
          map.setCenter(ido_kedo);
          // ピン: 最後の住所しか取れていない...
          // 住所という値しか取っていないから 緯度経度が最後だ..
          marker = new google.maps.Marker({
            map: map,
            position: ido_kedo,
            icon: {
              url: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png',
              scaledSize: new google.maps.Size(40, 40)
            }
          });
          // console.log(ido_kedo);
          // console.log(status); // OK
        } else {
          alert('該当する結果がありませんでした:' + status);
        }
      });
    })
  }

}
