// 未使用
// 投稿検索用 (home/search_post)

$(function () {
  $('.js_ajax_text').on('keyup', function () {
    let title = $.trim($(this).val()); // 入力値
    console.log(title);
    // ajaxリクエスト
    $.ajax({
      // リクエストのタイプ
      type: 'GET',
      // リクエストを送信するURL
      url: '/home_pages/homes', // ここの名前注意
      // サーバーに送信するデータ
      data:  { title: title },
      // サーバーから返却される型
      dataType: 'json'
    })
   })
});
