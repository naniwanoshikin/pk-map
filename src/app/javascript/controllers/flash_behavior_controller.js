import { Controller } from "@hotwired/stimulus"
// (layouts/_flash) (login/out, reviews, posts)
// (reviews/destroy.turbo_stream.erb)
export default class extends Controller {
  // このHTML要素が画面（DOM）に配置された瞬間に自動で1回だけ実行
  connect() {
    this.initFlash()
  }

  // HTML要素が画面から消える瞬間に自動実行（タイマーの漏れ防止）
  disconnect() {
    if (this.autoDeleteTimer) {
      clearTimeout(this.autoDeleteTimer)
      // console.log('clearTimeout');
    }
    if (this.fadeOutTimer) {
      clearTimeout(this.fadeOutTimer)
    }
  }

  initFlash() {
    // (layouts/_flash) <div data-controller> のこと
    const flash = this.element;

    // 過去に付与されたCSSクラスをリセット
    flash.classList.remove('hidden_up', 'hidden_out');
    // Flashメッセージを表示 review_ajax2回目以降も
    flash.style.display = "block";

    // 7秒後に自動で隠すタイマー
    this.autoDeleteTimer = setTimeout(() => {
      flash.classList.add('hidden_up'); // CSS 上がる
    }, 7000);

  }

  // [×] ボタンが押されたときに実行（data-action="click->flash-behavior#close"）
  close() {
    const flash = this.element;
    // [x]を押したとき
    console.log("stimulus [x]が押されました");
    flash.classList.add('hidden_out'); // CSS 消える
    clearTimeout(this.autoDeleteTimer); // タイマーをキャンセル

    this.fadeOutTimer = setTimeout(() => {
      if (flash.classList.contains('hidden_out')) {
        // console.log("0.5秒後にメッセージ削除");
        flash.style.display = "none"; // CSSよりも優先される
      }
    }, 500); // CSSのアニメーション時間に合わせる
  }
}
