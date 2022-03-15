var map;
var infowindow;
var marker;
var canvas = 'map';
var lat = '35.658704';
var lng = '139.745408';
var infoWindow = {
    id: 'pano',
    width: '400px',
    height: '300px'
};
var latlng = new google.maps.LatLng(lat, lng);

google.maps.event.addDomListener(window, 'load', function () {

    var mapdiv = document.getElementById(canvas);
    map = new google.maps.Map(mapdiv);
    map.setOptions({
        zoom: 14,
        center: latlng,
        mapTypeControl: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    // マーカーをセットする
    marker = new google.maps.Marker({
        position: latlng,
        map: map
    });

    // マーカーにclickイベントを登録  
    google.maps.event.addListener(marker, 'click', function () {

        // InfoWindowの設定
        var infowindow = new google.maps.InfoWindow({
            content: '<div id="' + infoWindow.id + '" style="width:' + infoWindow.width + ';height:' + infoWindow.height + '"></div>'
        });

        // InfoWindowにストリートビューを登録
        google.maps.event.addListener(infowindow, 'domready', function () {

            // ストリートビューのオプションを設定
            var panoramaOptions = {
                position: marker.getPosition(),
                linksControl: false,
                addressControl: false,
                enableCloseButton: false,
                panControl: false,
                scrollwheel: false
            };

            // ストリートビューオブジェクトを生成
            new google.maps.StreetViewPanorama(document.getElementById(infoWindow.id), panoramaOptions);
        });

        infowindow.open(marker.getMap(), marker);
    });
});