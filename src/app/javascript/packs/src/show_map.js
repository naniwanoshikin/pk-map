// (posts/show)
// windowグローバルに initMap を登録（Google Mapsからのコールバック用）
window.initMap = function () {
  const target = document.getElementById('detail_map')
  if (!target) return;

  // (show.html.slim) データ属性から座標を取得
  const lat = parseFloat(target.dataset.lat || 0);
  const lng = parseFloat(target.dataset.lng || 0);
  const content = target.dataset.content || "";
  const apiKey = target.dataset.apiKey || "";

  // 座標が取れていなければデバッグ
  if (lat === 0 && lng === 0) {
    console.warn("警告: 投稿の座標（緯度・経度）が取得できていません。");
    return;
  }

  // 地図の初期化
  const show_map = new google.maps.Map(target, {
    center: { lat: lat, lng: lng },
    zoom: 15,
    mapTypeControl: false, // 地図|航空写真
    mapId: 'DEMO_MAP_ID' // AdvancedMarkerElement に必須
  });

  // ピン（AdvancedMarker）の設置
  const marker = new google.maps.marker.AdvancedMarkerElement({
    position: { lat: lat, lng: lng },
    map: show_map,
    title: content
  });

  // 吹き出し（InfoWindow）の制御
  const infowindow = new google.maps.InfoWindow();
  marker.addEventListener('gmp-click', function () {
    infowindow.setContent(
      // 画像
      '<div class="infowindow">'
      + `<span class="">${content}</span>`
      + `<img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${lat},${lng}&key=${apiKey}' >`
      + '</div>'
    );
    infowindow.open(show_map, marker);
  });
}


// ページ遷移時や戻った時にもしっかり同期させる
document.addEventListener('turbo:load', () => {
  if (typeof window.initMap === 'function') {
    window.initMap();
  }
});
