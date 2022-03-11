// 検索用 (home)

$(function () {
  // home ページに記述するよりも後回しになる
  // $("h2").css("color", "red");
});


$(document).ready(function() {
   // console.log("test");
  $('.js_text').on('keyup', function () {
    let title = $.trim($(this).val());
    console.log(title);
    // ajaxリクエスト
    $.ajax({
      // リクエストのタイプ
      type: 'GET',
      // リクエストを送信するURL
      url: '/posts/post',
      // サーバーに送信するデータ
      data:  { post: title },
      // サーバーから返却される型
      dataType: 'json'
    })

   })
});