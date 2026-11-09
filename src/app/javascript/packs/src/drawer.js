// (layouts/header)
// 「いつかBootstrap 5にする時に、Offcanvasに変えてここは削除し、drawer_contoroller.jsに移行して記述する！」

// ドロワー初期化
const initDrawer = () => {
  if (window.$ && typeof window.$.fn.drawer !== 'undefined') {
    // console.log('a')
    // 起動
    $('.drawer').drawer();
    // console.log('b')

    // 背景の薄暗くなった部分をクリックするとドロワーが閉じる
    // off/onで二重登録防止
    $(document).off('click', '.drawer-overlay').on('click', '.drawer-overlay', function () {
      // 毎回直接 $('.drawer') を指定することで、スコープによるエラーを防止
      $('.drawer').drawer('close');
      console.log('c')
    });
  }
};
// 1. 通常のページ遷移時（初回表示など）
document.addEventListener('turbo:load', initDrawer);

// 2. 投稿フォーム送信失敗時（バリデーションエラー）、turbo:render イベントを発火。これにより投稿失敗後もドロワーが再起動できる。
document.addEventListener('turbo:render', initDrawer);
