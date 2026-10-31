// (posts/show)
// windowグローバルに initMap を登録（Google Mapsからのコールバック用）
window.initMap = function () {
  const target = document.getElementById('detail_map')
  if (!target) return;

  // (show.html.erb) データ属性から座標を取得
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

  // ピンの設置
  const marker = new google.maps.marker.AdvancedMarkerElement({
    map: show_map,
    position: { lat: lat, lng: lng },
    title: content,
    gmpClickable: true, // gmp-click が反応する
  });

  // 吹き出し
  const infowindow = new google.maps.InfoWindow();

  marker.element.addEventListener('gmp-click', function () {
    infowindow.setContent(
      // 画像
      '<div class="infowindow">'
      + `<span class="">${content}</span>`
      + `<img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${lat},${lng}&key=${apiKey}' >`
      + '</div>'
    );
    infowindow.open({
      anchor: marker,
      map: show_map,
    });
  });
}


// ページ遷移時や戻った時にもしっかり同期させる
document.addEventListener('turbo:load', () => {
  // 要素が存在するときだけクリア＆再初期化
  const target = document.getElementById('detail_map');
  if (target) {
    target.dataset.rendered = "false"; // 遷移時はフラグをリセット
    if (typeof window.initMap === 'function' && window.google && window.google.maps) {
      window.initMap();
    }
  }
});
