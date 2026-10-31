// (layouts/header)
// ドロワー初期化
const initDrawer = () => {
  if (window.$ && typeof window.$.fn.drawer !== 'undefined') {
    // 起動
    $('.drawer').drawer();

    // 背景の薄暗くなった部分をクリックするとドロワーが閉じる
    // 変数を使わず、直接呼び出す（off/onで二重登録を防止）
    $(document).off('click', '.drawer-overlay').on('click', '.drawer-overlay', function () {
      // 毎回直接 $('.drawer') を指定することで、スコープによるエラーを防止
      $('.drawer').drawer('close');
    });
  }
};
document.addEventListener('DOMContentLoaded', initDrawer);
document.addEventListener('turbo:load', initDrawer);
