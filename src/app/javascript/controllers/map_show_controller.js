import { Controller } from "@hotwired/stimulus"
// コードの意味: map_home_controller.js
export default class extends Controller {

  static values = {
    lat: Number,
    lng: Number,
    content: String,
    apiKey: String,
    mapId: { type: String, default: "DEMO_MAP_ID" } // GCPにて本番用に要作成
  }

  connect() {
    this.initMapOnLoad()
  }

  disconnect() {
    if (this.retryTimer) {
      clearTimeout(this.retryTimer)
    }
    this.infowindow?.close()
  }

  initMapOnLoad() {
    if (!window.google?.maps?.marker) {
      this.retryTimer = setTimeout(() => this.initMapOnLoad(), 100)
      return
    }
    this.initMap()
  }

  initMap() {
    // console.log('投稿詳細 地図の初期化')
    // (posts/show)_データ属性_そこの座標（緯度・経度）
    const lat = this.latValue
    const lng = this.lngValue

    if (lat === 0 || lng === 0) {
      console.warn("警告: 投稿の座標(lat, lng)が取得できていません")
      return
    }

    const position = { lat, lng }

    // 地図の生成
    this.map = new google.maps.Map(this.element, {
      center: position,
      zoom: 15,
      mapTypeControl: false,
      mapId: this.mapIdValue
    })

    // this.marker: メンバ変数
    // ピンを設置
    this.marker = new google.maps.marker.AdvancedMarkerElement({
      map: this.map,
      position: position,
      title: this.contentValue,
      gmpClickable: true,
    })

    this.infowindow = new google.maps.InfoWindow()
    // 吹き出しの中身をキャッシュ
    let cachedContent = null

    this.marker.addEventListener('gmp-click', () => {
      if (!cachedContent) {
        // console.log('div作成')
        cachedContent = this.buildInfoWindowContent({ lat, lng })
        this.infowindow.setContent(cachedContent)
      }
      this.infowindow.open({
        anchor: this.marker,
        map: this.map,
      })
    })

  }
  buildInfoWindowContent({ lat, lng }) {
    const wrapper = document.createElement('div')
    wrapper.className = 'infowindow'

    const span = document.createElement('span')
    span.textContent = this.contentValue
    // 画像
    const img = document.createElement('img')
    img.src = `https://maps.googleapis.com/maps/api/streetview?size=400x300&heading=160&fov=120&location=${lat},${lng}&key=${this.apiKeyValue}`
    img.alt = this.contentValue

    wrapper.append(span, img)
    return wrapper
  }
}
