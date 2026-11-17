// ゲストログイン (home_pages/_home) Stimulus なし

// Rails7 Turboの送信開始イベントをグローバルに監視
document.addEventListener('submit', (event) => {
  // <form class="button_to">
  const form = event.target;
  // <button data-guest-login-btn="true" type="submit">簡単ログイン</button>
  const isGuestLogin = form.querySelector('[data-guest-login-btn]');
  if (!isGuestLogin) return;

  // 背景の暗転レイヤー / ローディングボックス
  const overlay = document.querySelector(".first_load");
  const box = document.querySelector(".second_load");
  if (!overlay || !box) return;
  overlay.id = 'loading';
  box.id = 'loading_box';

  const div3 = document.createElement("div");
  div3.classList.add('loading-one', 'animation_loading');
  box.appendChild(div3);

  const p1 = document.createElement("p");
  p1.classList.add('loading-txt');
  p1.textContent = 'Loading';
  div3.appendChild(p1);
  // console.log('ゲストログイン ローディング');
});
