'use strict'; {
  // (reviews/form)
  // (★★☆☆☆)
  // (posts/show)
  const btn_stars = document.querySelector('.btn_ratings').children;
  // モーダル
  const stars = document.querySelector('.ratings').children;

  // '2'/5 hidden_field で Reviews(C)に送る
  const hiddenScore = document.getElementById("hidden_score");
  // '2' 値書き換え用
  const ratingValue = document.getElementById("rating_value");

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
}
