import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  // 検索① ターゲット
  static targets = ["canvas", "autocomplete"]

  // 型変換 HTMLの data-map-home-xxx-value から自動的に型変換
  static values = {
    userLat: Number,
    userLng: Number,
    userAddress: String,
    apiKey: String,
    feeds: Array
  }

  connect() {
    // console.log('map_home_controller 接続成功');
    // this.markers = []; // 検索入力用 既存の配列を管理するための空のマーカーリストを用意
    this.initMapOnLoad();
  }
  // this: このコントローラー自身 letの代わり
  // this.element: <div id='pkmap'>のこと
  // Google Maps API のロード完了を待って初期化
  initMapOnLoad() {
    if (typeof window.google === 'undefined' || !window.google.maps || !window.google.maps.marker) {
      setTimeout(() => this.initMapOnLoad(), 100);
      return;
    }
    // 地図初期化
    this.initMap();

    // 検索② 自動補完
    this.initAutocompleteElement();
  }

  initMap() {
    // console.log('home 地図の初期化');
    // (home_pages/home_map)_data-map-home-xxx-value
    // static values から安全に値を取得 (this.userLatValue のようにアクセス)
    // 自身の住所
    const userLat = this.userLatValue || 0;
    const userLng = this.userLngValue || 0;
    const user_LatLng = { lat: userLat, lng: userLng };
    const userAddress = this.userAddressValue;
    const apiKey = this.apiKeyValue;
    const feeds = this.feedsValue;

    // ⚠️ 座標が正常に取得できない場合
    if (isNaN(userLat) || isNaN(userLng) || (userLat === 0 && userLng === 0)) {
      console.warn("警告: 自身の座標が取得できません");
      return;
    }

    // 最新フィードの住所を判定
    let latest_feed_address = null;
    if (feeds && feeds.length > 0) {
      const feedLat = parseFloat(feeds[0].latitude);
      const feedLng = parseFloat(feeds[0].longitude);
      // 緯度経度が有効な数値（NaNでない）場合
      if (!isNaN(feedLat) && !isNaN(feedLng)) {
        latest_feed_address = { lat: feedLat, lng: feedLng };
      }
    }

    // 右側: グローバル(Google が用意したスクリプト)
    // 左側: ローカルで使える短い「あだ名」をつけた
    // 大文字は設計図
    // 地図
    const Map = google.maps.Map;
    // 吹き出し
    const InfoWindow = google.maps.InfoWindow;
    // ピン
    const AdvancedMarkerElement = google.maps.marker.AdvancedMarkerElement;
    // デザイン
    const PinElement = google.maps.marker.PinElement;

    // 地図の生成 中心位置を表示
    this.map = new Map(this.canvasTarget, {
      // 最新フィード なければあなた自身の住所
      center: latest_feed_address || user_LatLng,
      zoom: 12,
      mapTypeControl: false, // 地図|写真
      streetViewControl: false, // ストリートビューマーク
      mapId: 'DEMO_MAP_ID', // AdvancedMarkerElement に必要
      // mapTypeId: 'hybrid', // 航空写真とか..
    });

    // ピン要素のデザイン グリーン
    const pinGreen = new PinElement({
      background: "#34A853", // マップ公式の鮮やか緑
      borderColor: "#137333", // 枠線のディープグリーン
      glyphColor: "#ffffff",  // ピンの中央のドット色
    });

    // あなた自身の住所マーカー
    const userMarker = new AdvancedMarkerElement({
      map: this.map,
      position: user_LatLng,
      title: "自身の位置",
      content: pinGreen,
      gmpClickable: true, // gmp-click を機能させる為
    });

    // 吹き出しの生成 実物(インスタンス)
    this.infowindow = new InfoWindow();

    // あなた自身のピンをクリックしたとき
    userMarker.addEventListener('gmp-click', (event) => {
      // 他のフィードのクリックイベントと衝突・相殺を防ぐ
      event.stopPropagation();
      // あなた自身の位置と全く同じ座標(住所)のフィードを1つ特定
      const matchedFeed = feeds.find(feed => feed.address === userAddress);

      if (matchedFeed) {
        // 吹き出しを出す フィード情報付き
        this.openBalloon(userMarker, matchedFeed, apiKey);
      } else {
        // 投稿データがまだ無い場合は、 current_user から安全に住所を表示（クラッシュを防止）
        this.infowindow.setContent(
          `<div class="infowindow">`
          + `<span>${userAddress}</span>`
          + `<img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${user_LatLng.lat},${user_LatLng.lng}&key=${apiKey}' >`
          + '</div>'
        );
        // 吹き出しを表示
        this.infowindow.open({ anchor: userMarker, map: this.map });
      }
    });

    // ② 各フィードのマーカー配置
    feeds.forEach(feed => {
      const feedLat = parseFloat(feed.latitude);
      const feedLng = parseFloat(feed.longitude);

      if (isNaN(feedLat) || isNaN(feedLng)) {
        console.warn(`警告:住所: ${feed.address} (feedID ${feed.id}) の座標が不正なため表示できません`);
        return;
      }

      // あなた自身の住所とフィードが重複しないよう
      if (feed.address !== userAddress) {
        const targetMarker = new AdvancedMarkerElement({
          map: this.map,
          position: { lat: feedLat, lng: feedLng },
          title: feed.address,
          gmpClickable: true,
        });
        targetMarker.addEventListener('gmp-click', (event) => {
          event.stopPropagation();
          // 吹き出しを表示
          this.openBalloon(targetMarker, feed, apiKey);
        });
      }
    });
  }

  // ★ Places API (New) オートコンプリートの初期化
  async initAutocompleteElement() {
    // ターゲットが存在しない画面の場合はスキップ
    if (!this.hasAutocompleteTarget) return;

    console.log('cccccc')
    // places ライブラリをロード
    await google.maps.importLibrary("places");

    // 🌟【最重要】PC画面でも強制的にスマホ用の真っ白全画面が暴発するのを永久に停止する設定。
    // これにより、画面幅に関わらず「常にインプットの直下にドロップダウン（POPUP）」を出します。
    this.autocompleteTarget.forceDisplayMode = "POPUP";


    // 必要最小限のフィールドに制限（従量課金対策）
    this.autocompleteTarget.requestedFields = ["geometry", "displayName"];
  }


  // (search_spot.html)
  // ★ 場所が選択されたときに地図を移動させる (gmp-placechange)
  handlePlaceChange() {
    // 新型のコンポーネントから直接選択された「Placeインスタンス」を引っこ抜く
    const place = this.autocompleteTarget.place;

    // place.geometry が存在するか、ロードが完了しているか安全にチェック
    if (place && place.geometry && this.map) {
      // 選択された位置へスムース移動＆ズーム
      this.map.panTo(place.geometry);
      this.map.setZoom(15);
    }
  }


  // ★ 検索窓でのEnterキーによる暴発リロードを完全にブロック
  preventSubmit(event) {
    if (event.key === "Enter") {
      event.preventDefault();
    }
  }

  // ★ 虫眼鏡ボタンが直接クリックされた際の処理
  search() {
    if (!this.hasAutocompleteTarget) return;
    // 新型コンポーネント（gmp-place-autocomplete）の内包するinputから安全に文字列を取得
    const inputElement = this.autocompleteTarget.querySelector('input');
    const query = inputElement ? inputElement.value : "";

    console.log('虫眼鏡')
    if (!query) return;
    console.log('入力されたワードで検索を実行:', query);
    // 必要に応じてジオコーディング（住所文字列→緯度経度）をここに追記可能です
  }

  // 吹き出しを表示する共通メソッド
  openBalloon(targetMarker, feedData, apiKey) {
    console.log(feedData.address + 'をクリック');
    this.infowindow.setContent(
      // リンク + 画像
      '<div class="infowindow">'
      + `<a href='/posts/${feedData.id}'>${feedData.address}</a>`
      + `<img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${feedData.latitude},${feedData.longitude}&key=${apiKey}' >`
      + '</div>'
    );
    // 吹き出しを表示
    this.infowindow.open({
      anchor: targetMarker,
      map: this.map,
    });
  }
}
