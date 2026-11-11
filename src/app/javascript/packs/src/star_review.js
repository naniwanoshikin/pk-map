// (★★☆☆☆) を操作 (reviews/form)
const initStarReview = () => {
  // ★★☆☆☆ モーダル開く前
  const btnRatingsContainer = document.getElementById('openModalBtn');
  // ★★☆☆☆ モーダル開いた後 フォーム
  const ratingsContainer = document.querySelector('.ratings');
  // 現在のページに無いなら処理終了
  if (!btnRatingsContainer || !ratingsContainer) return;

  // ★★☆☆☆ モーダル開く前
  const btn_stars = btnRatingsContainer.querySelectorAll('.star_trigger');
  // ★★☆☆☆ モーダル開いた後
  const stars = ratingsContainer.children;

  // '2'/5 hidden_field ▶︎ Reviews(C)
  const hiddenScore = document.getElementById("hidden_score");
  // '2' 値書き換え用
  const ratingValue = document.getElementById("rating_value");

  // 万が一無い場合も終了
  if (!hiddenScore || !ratingValue) return;


  // クリックした星の数
  let index;

  // ===========================================
  // モーダルを開く前後のクリックした星が連動
  // ===========================================
  btn_stars.forEach((btnStar, i) => {
    btnStar.addEventListener('click', () => {
      const selectedScore = i + 1; // 1〜5 の数値
      console.log(`星${selectedScore}をセット`);

      // 1. モーダル内の隠しフォームとテキスト値を同期
      hiddenScore.value = selectedScore;
      ratingValue.textContent = selectedScore;

      // 2. 既存のマウスアウト時の表示ロジック（index）と同期させる
      index = i;

      // 3. モーダル内および開く前の星の見た目を「塗りつぶす」
      for (let j = 0; j < stars.length; j++) {
        if (j <= i) {
          stars[j].classList.remove("far");
          stars[j].classList.add("fas");
          btn_stars[j].classList.remove("far");
          btn_stars[j].classList.add("fas");
        } else {
          stars[j].classList.add("far");
          stars[j].classList.remove("fas");
          btn_stars[j].classList.add("far");
          btn_stars[j].classList.remove("fas");
        }
      }
    });
  });

  // =======================================================
  // モーダル内で星をポチポチ操作する
  // =======================================================
  for (let i = 0; i < stars.length; i++) {
    // 1. その星にマウスが乗ったとき
    stars[i].addEventListener("mouseover", () => {
      // 全ての星を
      for (let j = 0; j < stars.length; j++) {
        // モーダル開いた後の⭐︎
        stars[j].classList.add("far"); // 一旦くり抜いて
        stars[j].classList.remove("fas");
      }
      // マウスが乗った星までを
      for (let j = 0; j <= i; j++) {
        // console.log('a')
        stars[j].classList.remove("far"); // 一旦くり抜いて ☆
        stars[j].classList.add("fas"); // 塗りつぶす ★
      }
    })

    // 2. その星をクリックした時
    stars[i].addEventListener("click", () => {
      hiddenScore.value = i + 1; // i = 0 - 4
      // '2'/5
      ratingValue.textContent = hiddenScore.value;
      console.log(`星${hiddenScore.value}をクリック`)

      index = i; // 0 - 4

      // 裏側の元の画面の星もリアルタイムに塗りつぶす
      for (let j = 0; j < stars.length; j++) {
        if (j <= i) {
          // その星までを
          btn_stars[j].classList.remove("far");
          btn_stars[j].classList.add("fas"); // 塗りつぶす ★
        } else {
          // その星以降を
          btn_stars[j].classList.add("far");
          btn_stars[j].classList.remove("fas"); // くり抜く ☆
        }
      }
    })


    // 3. その星からマウスが離れたとき
    stars[i].addEventListener("mouseout", () => {
      // 全ての星を
      for (let j = 0; j < stars.length; j++) {
        // モーダル開いた後の⭐︎
        stars[j].classList.add("far"); // 一旦くり抜いて
        stars[j].classList.remove("fas");
        // モーダル開く前の⭐︎ 一旦くり抜く
        btn_stars[j].classList.add("far");
        btn_stars[j].classList.remove("fas");
      }
      // クリックした星までを
      for (let j = 0; j <= index; j++) {
        stars[j].classList.remove("far");
        stars[j].classList.add("fas"); // 塗りつぶす
        // モーダル開く前の⭐︎ 塗りつぶす
        btn_stars[j].classList.remove("far");
        btn_stars[j].classList.add("fas");
      }
    })
  }

}

// 初回ロード＋非同期遷移
document.addEventListener('turbo:load', initStarReview);
document.addEventListener('turbo:render', initStarReview); // 投稿失敗時など
