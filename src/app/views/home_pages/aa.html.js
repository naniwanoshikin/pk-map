var map = null;
var infowindow = new google.maps.InfoWindow();
var gmarkers = [];
var i = 0;

function inicializar() {
  // 初期設定
  var option = {
    // ズームレベル
    zoom: 12,
    // 中心座標
    center: new google.maps.LatLng(35.1683085, 136.9072405),
    // タイプ (ROADMAP・SATELLITE・TERRAIN・HYBRIDから選択)
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), option);
  google.maps.event.addListener(map, "click", function () { infowindow.close(); });

  // ポイントの追加
  var point = new google.maps.LatLng(35.1676114, 136.904148);
  var marker = create_maker(point, "info", "<img src='画像パス' /><br><a href='URL' target='_blank'>タイトル01</a>");

  var point = new google.maps.LatLng(35.1675021, 136.8906085);
  var marker = create_maker(point, "info", "<img src='画像パス' /><br><a href='URL' target='_blank'>タイトル02</a>");

  var point = new google.maps.LatLng(35.1727874, 136.8852535);
  var marker = create_maker(point, "info", "<img src='画像パス' /><br><a href='URL' target='_blank'>タイトル03</a>");
}

function create_maker(latlng, label, html) {
  // マーカーを生成
  var marker = new google.maps.Marker({ position: latlng, map: map, title: label });
  // マーカーをクリックした時の処理
  google.maps.event.addListener(marker, "click", function () {
    infowindow.setContent(html);
    infowindow.open(map, marker);
  });
  gmarkers[i] = marker;
  i++;
  return marker;
}

function map_click(i) {
  google.maps.event.trigger(gmarkers[i], "click");
}

google.maps.event.addDomListener(window, "load", inicializar);