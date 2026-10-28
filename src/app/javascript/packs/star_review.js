// (★★☆☆☆) を操作
const initStarReview = () => {
  // ★★☆☆☆ モーダル開く前
  const btnRatingsContainer = document.querySelector('.btn_ratings');
  // ★★☆☆☆ モーダル画面上 フォーム (reviews/form)
  const ratingsContainer = document.querySelector('.ratings');
  // 現在のページに無いなら処理終了（ガード）
  if (!btnRatingsContainer || !ratingsContainer) return;

  // ⭐︎ モーダル開く前
  const btn_stars = btnRatingsContainer.children;
  // ⭐︎ モーダル画面上
  const stars = ratingsContainer.children;

  // '2'/5 hidden_field ▶︎ Reviews(C)
  const hiddenScore = document.getElementById("hidden_score");
  // '2' 値書き換え用
  const ratingValue = document.getElementById("rating_value");

  // 万が一無い場合も想定してガード
  if (!hiddenScore || !ratingValue) return;


  // クリックした星の数
  let index;

  // それぞれの星
  for (let i = 0; i < stars.length; i++) {
    // その星にマウスが乗ったとき
    stars[i].addEventListener("mouseover", () => {
      // 全ての星を
      for (let j = 0; j < stars.length; j++) {
        // console.log(stars.length)
        stars[j].classList.add("far"); // 一旦くり抜いて
        stars[j].classList.remove("fas");
      }
      // マウスが乗った星までを
      for (let j = 0; j <= i; j++) {
        // console.log('a')
        stars[j].classList.remove("far");
        stars[j].classList.add("fas"); // 塗りつぶす
      }
    })

    // その星をクリックした時
    stars[i].addEventListener("click", () => {
      hiddenScore.value = i + 1; // i = 0 - 4
      // '2'/5
      ratingValue.textContent = hiddenScore.value;
      // クリックした星の数
      index = i; // 0 - 4
    })

    // その星からマウスが離れたとき
    stars[i].addEventListener("mouseout", () => {
      // 全ての星を
      for (let j = 0; j < stars.length; j++) {
        stars[j].classList.add("far"); // 一旦くり抜いて
        stars[j].classList.remove("fas");
        // (posts/show)部分も一旦くり抜く
        btn_stars[j].classList.add("far");
        btn_stars[j].classList.remove("fas");
      }
      // クリックした星までを
      for (let j = 0; j <= index; j++) {
        stars[j].classList.remove("far");
        stars[j].classList.add("fas"); // 塗りつぶす
        // (posts/show)部分も塗りつぶす
        btn_stars[j].classList.remove("far");
        btn_stars[j].classList.add("fas");
      }
    })
  }

  // =======================================================
  // ブラウザのアクセシビリティ警告（aria-hidden）を解決
  // 1. モーダルを閉じるときは、([×]or[閉じる])のフォーカスを外して、
  // 2. 閉じ終わったら、元の画面★★☆☆☆にフォーカスを戻してあげる
  // =======================================================
  // ⭐︎⭐︎⭐︎⭐︎⭐︎ ブラウザ
  const modalElement = document.getElementById('exampleModal');
  if (modalElement && typeof $ !== 'undefined') {
    // BootstrapのイベントをjQuery経由でキャッチ

    // 1. モーダルが閉じ始める瞬間（hide）
    $(modalElement).off('hide.bs.modal').on('hide.bs.modal', function () {
      // 現在ブラウザでフォーカスが当たっている要素([×]or[閉じる])
      const activeEl = document.activeElement;
      // このモーダル内部の要素があれば
      if (activeEl && this.contains(activeEl)) {
        // <button.close> や <button.btn-secondary> など、どれであっても強制解除(blur)
        activeEl.blur();
      }
    });
    // 2. モーダルが閉じ終わった瞬間（hidden）、
    $(modalElement).off('hidden.bs.modal').on('hidden.bs.modal', function () {
      // フォーカスを戻す
      btnRatingsContainer.focus();
    });
  }
}

// ページ読み込み・Turbo遷移の両方で発火させる
document.addEventListener('DOMContentLoaded', initStarReview);
document.addEventListener('turbo:load', initStarReview);
