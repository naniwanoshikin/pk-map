import { Controller } from "@hotwired/stimulus"
// コードの意味: map_home_controller.js
export default class extends Controller {

  static values = {
    lat: Number,
    lng: Number,
    content: String,
    apiKey: String
  }

  connect() {
    this.initMapOnLoad();
  }

  initMapOnLoad() {
    if (typeof window.google === 'undefined' || !window.google.maps || !window.google.maps.marker) {
      setTimeout(() => this.initMapOnLoad(), 100);
      return;
    }
    this.initMap();
  }

  initMap() {
    // console.log('詳細地図 初期化');
    // (posts/show)_データ属性_そこの座標
    const lat = this.latValue || 0;
    const lng = this.lngValue || 0;
    const content = this.contentValue || "";
    const apiKey = this.apiKeyValue || "";

    if (isNaN(lat) || isNaN(lng) || (lat === 0 && lng === 0)) {
      console.warn("警告: 投稿の座標（緯度・経度）が取得できていません");
      return;
    }

    const Map = google.maps.Map;
    const AdvancedMarkerElement = google.maps.marker.AdvancedMarkerElement;
    const InfoWindow = google.maps.InfoWindow;

    // 地図の生成
    this.map = new Map(this.element, {
      center: { lat: lat, lng: lng },
      zoom: 15,
      mapTypeControl: false,
      mapId: 'DEMO_MAP_ID'
    });

    // this.marker: メンバ変数
    // ピンを設置
    this.marker = new AdvancedMarkerElement({
      map: this.map,
      position: { lat: lat, lng: lng },
      title: content,
      gmpClickable: true,
    });

    this.infowindow = new InfoWindow();

    this.marker.addEventListener('gmp-click', () => {
      this.infowindow.setContent(
        // 画像
        '<div class="infowindow">'
        + `<span>${content}</span>`
        + `<img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${lat},${lng}&key=${apiKey}' >`
        + '</div>'
      );
      this.infowindow.open({
        anchor: this.marker,
        map: this.map,
      });
    });
  }
}
