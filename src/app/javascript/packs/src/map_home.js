import { setOptions, importLibrary } from "@googlemaps/js-api-loader";

let map;
let infowindow; // 吹き出し

// 地図の初期化
async function initMap(mapElement) {
  console.log('Google Mapsの読み込み開始');
  // 検索入力用 エラー
  // const geocoder = new google.maps.Geocoder();

  // data属性: (home_pages/home_map)
  // 自身の住所 (緯度: 経度:)
  const user_LatLng = {
    lat: parseFloat(mapElement.dataset.userLat),
    lng: parseFloat(mapElement.dataset.userLng)
  }
  const userAddress = mapElement.dataset.userAddress;
  const apiKey = mapElement.dataset.apiKey;
  const feeds = JSON.parse(mapElement.dataset.feeds || '[]');

  // 1. 新しいAPIの書き方：オプションをセットする
  setOptions({
    key: apiKey,
    v: "weekly" // バージョン指定
  });


  try {
    // mapsライブラリと markerライブラリを非同期でインポート
    const { Map, InfoWindow } = await importLibrary("maps");
    const { AdvancedMarkerElement, PinElement } = await importLibrary("marker");

    // 最新フィードの住所 あれば(条件演算子)
    const latest_feed_address = feeds[0] ? {
      lat: parseFloat(feeds[0].latitude),
      lng: parseFloat(feeds[0].longitude)
    } : null

    // 地図の生成 中心位置を表示
    map = new Map(mapElement, {
      // 最新フィード なければ自身の住所
      center: latest_feed_address || user_LatLng,
      zoom: 12,
      mapTypeControl: false, // 地図|写真
      streetViewControl: false, // ストリートビューマーク
      mapId: 'DEMO_MAP_ID', // AdvancedMarkerElement に必要
      // mapTypeId: 'hybrid', // 航空写真とか..
    });

    // 吹き出しインスタンスの生成
    infowindow = new InfoWindow();

    // 新しいピン要素を作成 背景色をデザイン
    const pinGreen = new PinElement({
      background: "#34A853", // マップ公式の鮮やかなグリーン
      borderColor: "#137333", // 枠線のディープグリーン
      glyphColor: "#ffffff",  // ピンの中央のドットの色（白）
    });

    // 自身の住所マーカー（緑のピン）
    const userMarker = new AdvancedMarkerElement({
      map: map,
      position: user_LatLng,
      title: "自身の位置",
      content: pinGreen,
      gmpClickable: true, // gmp-click を機能させる為
    });

    // 自身の住所の吹き出しを作成
    userMarker.addEventListener('gmp-click', (event) => {
      // 他のフィードのクリックイベントと衝突・相殺するのを防ぐ
      event.stopPropagation();
      // 自身の位置と全く同じ座標、もしくは同じ住所のフィードを1つ特定
      const matchedFeed = feeds.find(feed => feed.address === userAddress);

      if (matchedFeed) {
        // フィード情報付きの吹き出しを出す
        openBalloon(userMarker, matchedFeed, apiKey);
      } else {
        // 投稿データがまだ無い場合は、current_userから安全に住所を表示する（クラッシュを防止）
        infowindow.setContent(
          `<div class="infowindow">`
          + `<span>${userAddress}</span>`
          + `<img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${user_LatLng.lat},${user_LatLng.lng}&key=${apiKey}' >`
          + '</div>'
        );
        // 吹き出しを表示
        infowindow.open({ anchor: userMarker, map: map });
      }
    });


    // フィードの個々のマーカーを配置
    feeds.forEach(feed => {
      console.log(feed.address);
      // 自身の住所/フィードが重複しないよう
      if (feed.address !== userAddress) {
        const targetMarker = new google.maps.marker.AdvancedMarkerElement({
          map: map,
          position: {
            lat: parseFloat(feed.latitude),
            lng: parseFloat(feed.longitude)
          },
          title: feed.address,
          gmpClickable: true,
        });
        // 吹き出しを表示
        targetMarker.addEventListener('gmp-click', (event) => {
          event.stopPropagation();
          openBalloon(targetMarker, feed, apiKey);
        });
      }
    });
  } catch (error) {
    console.error("Google Mapsの読み込み中にエラーが発生:", error);
  }

  // 吹き出しを表示する
  function openBalloon(targetMarker, feedData, apiKey) {
    console.log(feedData.address + 'をクリック')
    infowindow.setContent(
      // リンク + 画像
      '<div class="infowindow">'
      + `<a href='/posts/${feedData.id}'>${feedData.address}</a>`
      + `<img src='https://maps.googleapis.com/maps/api/streetview?size=640x480&heading=160&fov=120&location=${feedData.latitude},${feedData.longitude}&key=${apiKey}' >`
      + '</div>'
    );
    // 吹き出しを表示
    infowindow.open({
      anchor: targetMarker,
      map: map,
    });
  };
}

// 1. 地図要素が存在するかチェックして初期化を呼ぶ関数を「定義」
function initMapOnLoad() {
  const mapElement = document.getElementById('pkmap');
  if (mapElement) {
    initMap(mapElement);
  }
}

// 画面遷移時（Turbo）と初回読み込み（DOMContentLoaded）の両方
document.addEventListener("turbo:load", initMapOnLoad);
document.addEventListener("DOMContentLoaded", initMapOnLoad);
