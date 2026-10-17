// 未使用 できず

function initMap() {
  const target = document.getElementById('detail_map');
  if (!target) return;

  // HTMLのdata属性から安全に値を取得
  const lat = parseFloat(target.dataset.lat) || 0;
  const lng = parseFloat(target.dataset.lng) || 0;
  const content = target.dataset.content || "";
  const apiKey = target.dataset.mapApiKey;

  if (lat === 0 && lng === 0) {
    console.warn("警告: 投稿の座標（緯度・経度）が取得できていません。");
  }

  const show_map = new google.maps.Map(target, {
    center: { lat: lat, lng: lng },
    zoom: 15,
    mapTypeControl: false,
    mapId: 'DEMO_MAP_ID' 
  });

  const marker = new google.maps.marker.AdvancedMarkerElement({
    position: { lat: lat, lng: lng },
    map: show_map,
    title: content
  });

  const infowindow = new google.maps.InfoWindow();
  
  marker.addListener('click', function() {
    infowindow.setContent(
      '<div class="infowindow">'
      + `<span class="">${content}</span>`
      + `<img src='https://googleapis.com{lat},${lng}&key=${apiKey}' >`
      + '</div>'
    );
    infowindow.open(show_map, marker);
  });
}

// グローバルスコープ（window）に登録して、Google Mapsのcallbackから呼べるようにする
window.initMap = initMap;

// Turbolinksの画面遷移に対応
document.addEventListener('turbolinks:load', initMap);

// ページを戻った時にもしっかり再描画させる
