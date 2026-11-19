import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  // 検索① ターゲット
  static targets = ["canvas", "autocomplete", "feedUpdater"]

  // 型変換 HTMLの data-map-home-xxx-value から自動的に型変換
  static values = {
    userLat: Number,
    userLng: Number,
    userAddress: String,
    apiKey: String,
    feeds: Array
  }

  connect() {
    // this.feedMarkers = [] // フィードのピンを管理する配列
    this.initMapOnLoad()
  }
  // this: このコントローラー自身 letの代わり
  // this.element: <div id='pkmap'>のこと
  // Google Maps API のロード完了を待って初期化
  initMapOnLoad() {
    if (typeof window.google === 'undefined' || !window.google.maps || !window.google.maps.marker) {
      setTimeout(() => this.initMapOnLoad(), 100)
      return
    }
    // 地図初期化
    this.initMap()
    // 検索② 自動補完
    this.initAutocompleteElement()
  }

  initMap() {
    // console.log('home 地図初期化');
    // (home_pages/home_map)_data-map-home-xxx-value
    // static values から安全に値を取得 (this.userLatValue のようにアクセス)
    // 自身の住所
    const userLat = this.userLatValue || 0
    const userLng = this.userLngValue || 0
    const user_LatLng = { lat: userLat, lng: userLng }
    const userAddress = this.userAddressValue
    const feeds = this.feedsValue

    // ⚠️ 座標が正常に取得できない場合
    if (isNaN(userLat) || isNaN(userLng) || (userLat === 0 && userLng === 0)) {
      console.warn("警告: 自身の座標が取得できません")
      return;
    }

    // 最新フィードの住所を判定
    let latest_feed_address = null
    if (feeds && feeds.length > 0) {
      const feedLat = parseFloat(feeds[0].latitude)
      const feedLng = parseFloat(feeds[0].longitude)
      // 緯度経度が有効な数値（NaNでない）場合
      if (!isNaN(feedLat) && !isNaN(feedLng)) {
        latest_feed_address = { lat: feedLat, lng: feedLng }
      }
    }

    // 右側: グローバル(Google が用意したスクリプト)
    // 左側: ローカルで使える短い「あだ名」をつけた 設計図 分割代入
    // {地図, 吹き出し}
    const { Map, InfoWindow } = google.maps
    // {ピン, デザイン}
    const { AdvancedMarkerElement, PinElement } = google.maps.marker

    // 地図の生成 中心位置を表示
    this.map = new Map(this.canvasTarget, {
      // 最新フィード なければあなた自身の住所
      center: latest_feed_address || user_LatLng,
      zoom: 12,
      mapTypeControl: false, // 地図|写真
      streetViewControl: false, // ストリートビューマーク
      mapId: 'DEMO_MAP_ID', // AdvancedMarkerElement に必要
      // mapTypeId: 'hybrid', // 航空写真とか..
    })

    // ピン要素のデザイン グリーン
    const pinGreen = new PinElement({
      background: "#34A853", // マップ公式の鮮やか緑
      borderColor: "#137333", // 枠線のディープグリーン
      glyphColor: "#ffffff",  // ピンの中央のドット色
    })

    // あなた自身の住所マーカー
    const userMarker = new AdvancedMarkerElement({
      map: this.map,
      position: user_LatLng,
      title: "自身の位置",
      content: pinGreen,
      gmpClickable: true, // gmp-click を機能させる為
    })

    // 吹き出しの生成 実物(インスタンス)
    this.infowindow = new InfoWindow()

    // あなた自身のピンをクリックしたとき
    userMarker.addEventListener('gmp-click', (event) => {
      // 他のフィードのクリックイベントと衝突・相殺を防ぐ
      event.stopPropagation();
      // あなた自身の位置と全く同じ座標(住所)のフィードを1つ特定
      const matchedFeed = feeds.find(feed => feed.address === userAddress)

      if (matchedFeed) {
        // 吹き出しを出す フィード情報付き
        this.openBalloon(userMarker, matchedFeed)
      } else {
        // 投稿データがまだ無い場合は、 current_user から安全に住所を表示（クラッシュを防止）
        this.infowindow.setContent(`
          <div class="infowindow">
            <span>${userAddress}</span>
            <img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${user_LatLng.lat},${user_LatLng.lng}&key=${this.apiKeyValue}' >
          </div>
        `)
        // 吹き出しを表示
        this.infowindow.open({ anchor: userMarker, map: this.map })
      }
    })

    // ② 各フィードのマーカー配置
    feeds.forEach(feed => {
      const feedLat = parseFloat(feed.latitude)
      const feedLng = parseFloat(feed.longitude)

      if (isNaN(feedLat) || isNaN(feedLng)) {
        console.warn(`警告:住所: ${feed.address} (feedID ${feed.id}) の座標が不正なため表示できません`)
        return
      }

      // あなた自身の住所とフィードが重複しないよう
      if (feed.address !== userAddress) {
        const targetMarker = new AdvancedMarkerElement({
          map: this.map,
          position: { lat: feedLat, lng: feedLng },
          title: feed.address,
          gmpClickable: true,
        })
        targetMarker.addEventListener('gmp-click', (event) => {
          event.stopPropagation();
          // 吹き出しを表示
          this.openBalloon(targetMarker, feed)
        })
      }
    })
  }

  // ★ オートコンプリートの初期化
  async initAutocompleteElement() {
    // ターゲットが存在しない画面はスキップ
    if (!this.hasAutocompleteTarget) return

    console.log('Places API (New) ')
    await google.maps.importLibrary("places")
    // ▶︎<gmp-place-autocomplete> が起動
  }


  // ★ 1. 候補から場所が選択されたとき
  // (home_login)_(gmp-select)
  async handlePlaceSelect(event) {
    // 候補選択が動いたフラグを立てる（Enterキーとの二重実行防止）
    this.isSelectingFromList = true

    // 1. 選択された候補(placePrediction)をPlaceオブジェクトに変換
    const place = event.placePrediction.toPlace()
    // 2. 座標と名前をGoogleからAPIにリクエスト（課金最小化）
    await place.fetchFields({
      fields: ["location", "displayName"]
    });
    if (place.location) {
      this.moveMapAndSetMarker(place.location, place.displayName)
    }
    // 少し待ってからフラグを戻す
    setTimeout(() => { this.isSelectingFromList = false; }, 300)
  }

  // ★ 2. 候補を選ばず、いきなりEnterキーを押したとき
  handleEnterSearch(event) {
    // 検索フォームのEnterキーによる暴発リロードを防止
    event.preventDefault()

    // 候補リストから選んだ直後のEnterならスキップ（二重検索の防止）
    setTimeout(() => {
      if (this.isSelectingFromList) return
      this.searchByText()
    }, 100)
  }


  // ★ 3. 入力テキストから直接検索 Places API (New)
  async searchByText() {
    if (!this.hasAutocompleteTarget) return

    // <gmp-place-autocomplete> の入力値を取得
    const query = this.autocompleteTarget.value?.trim()
    if (!query) return;

    try {
      const { Place } = await google.maps.importLibrary("places")
      // Googleマップと同じ高精度なテキスト検索を実行
      const { places } = await Place.searchByText({
        textQuery: query,
        fields: ["location", "displayName"],
        region: "jp",
        maxResultCount: 1
      });

      if (places?.[0]?.location) {
        this.moveMapAndSetMarker(places[0].location, places[0].displayName)
      } else {
        alert("該当する場所が見つかりませんでした。候補から選択してみてください。")
      }
    } catch (error) {
      console.error("テキスト検索エラー:", error)
    }
  }

  // ★ 4. 地図の移動 + ピン立て 共通
  moveMapAndSetMarker(location, title) {
    if (!this.map) return;
    // 選択された位置へスムース移動＆ズーム
    this.map.panTo(location)
    this.map.setZoom(15)

    // 4. 既存の検索ピンがあれば消してから新しく立てる
    if (this.searchMarker) {
      this.searchMarker.map = null
    }
    this.searchMarker = new google.maps.marker.AdvancedMarkerElement({
      map: this.map,
      position: location,
      title: title
    })
  }


  // ★ Turbo Stream #map_feeds_updater 更新時にピンだけを再描画
  feedUpdaterTargetConnected(element) {
    this.feedsValue = JSON.parse(element.dataset.feeds || "[]")
    // 地図のピンを再描画（既存のピンを消して新しい feeds で立て直す）
    this.initMap()
  }


  // 吹き出し表示 共通
  openBalloon(targetMarker, feedData) {
    console.log(feedData.address + 'をクリック')
    this.infowindow.setContent(`
      <div class="infowindow">
        <a href="/posts/${feedData.id}">${feedData.address}</a>
        <img src="https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${feedData.latitude},${feedData.longitude}&key=${this.apiKeyValue}" >
      </div>
    `);
    // 吹き出しを表示
    this.infowindow.open({
      anchor: targetMarker,
      map: this.map,
    });
  }
}
