// ゲストログイン (home_pages/_home.html.erb)
// Stimulus化する必要はなし

// Rails7 Turboの送信開始イベントをグローバルに監視
document.addEventListener('turbo:submit-start', (event) => {
  // 送信されたターゲット（form要素）
  const form = event.target;
  // 送信されたフォームの中に [data-guest-login-btn] を持つボタンがあるか判定
  const isGuestLogin = form.querySelector('[data-guest-login-btn]');
  if (!isGuestLogin) return;

  // console.log('ゲストログイン ローディング');

  // 1. 背景の暗転レイヤーを表示
  const div1 = document.querySelector(".first_load");
  if (div1) div1.id = 'loading';

  // 2. ローディングボックスを表示
  const div2 = document.querySelector(".second_load");
  if (div2) {
    div2.id = 'loading_box';

    const div3 = document.createElement("div");
    div3.classList.add('loading-one', 'animation_loading');
    div2.appendChild(div3);

    const p1 = document.createElement("p");
    p1.classList.add('loading-txt');
    p1.textContent = 'Loading';
    div3.appendChild(p1);
  }
});
