'use strict'; {
  // (comments/form)
  // (★★☆☆☆)
  const stars = document.querySelector('.ratings').children;

  // '2'/5 hidden_field で Comments(C)に送る値
  const hiddenScore = document.getElementById("hidden_score");
  // '2'/5 画面に出る値
  const ratingValue = document.getElementById("rating_value");

  // クリックした星の数
  let index;

  // それぞれの星について
  for (let i = 0; i < stars.length; i++) {
    // その星にマウスが乗ったとき
    stars[i].addEventListener("mouseover", function () {
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
    stars[i].addEventListener("click", function () {
      hiddenScore.value = i + 1; // i = 0 - 4
      // '2'/5
      ratingValue.textContent = hiddenScore.value;
      // クリックした星の数
      index = i; // 0 - 4
    })

    // その星からマウスが離れたとき
    stars[i].addEventListener("mouseout", function () {
      // 全ての星を
      for (let j = 0; j < stars.length; j++) {
        stars[j].classList.add("far"); // 一旦くり抜いて
        stars[j].classList.remove("fas");
      }
      // クリックした星までを
      for (let j = 0; j <= index; j++) {
        stars[j].classList.remove("far");
        stars[j].classList.add("fas"); // 塗りつぶす
      }
    })
  }
}
