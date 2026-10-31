// (layouts/application)
// ajaxしている外部ページ（reviews/create.js.erb）からもflashを呼び出せるよう、グローバル（window）に登録
window.refreshFlashBehavior = function () {

  const flash = document.getElementById('flash_messages');
  // console.log("Flash グローバル関数実行");
  if (!flash) return;

  // 過去に付与されたCSSクラスをリセット
  flash.classList.remove('hidden_up', 'hidden_out');
  // Flashメッセージを表示 review_ajax2回目以降も
  flash.style.display = "block";

  // [x] 閉じるボタン
  const close = flash.querySelector('.close');
  if (close) {
    // console.log("[x]ボタンあり");
    const autoDeleteTimer = setTimeout(() => {
      console.log("7秒経過");
      flash.classList.add('hidden_up'); // CSS 上がる
    }, 7000);

    // [x]を押したとき
    close.addEventListener('click', () => {
      console.log("[x]が押されました");
      flash.classList.add('hidden_out'); // CSS 消える
      clearTimeout(autoDeleteTimer); // 7秒タイマーをキャンセル

      setTimeout(() => {
        if (flash.classList.contains('hidden_out')) {
          // console.log("0.5秒後にメッセージ削除");
          flash.style.display = "none"; // CSSよりも優先される
        }
      }, 500); // CSSのアニメーション時間に合わせる

    }, { once: true }); // 1回だけ実行
  }
};

// 初回画面表示（DOM構築完了時）に実行
document.addEventListener('DOMContentLoaded', () => {
  window.refreshFlashBehavior();
});
