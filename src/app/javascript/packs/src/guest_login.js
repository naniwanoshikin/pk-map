// Rails7 Turbo 送信開始イベント
document.addEventListener('turbo:submit-start', (event) => {
  // <form class="button_to">
  const form = event.target;
  // <button data-guest-login-btn="true" type="submit">簡単ログイン</button>
  const isGuestLogin = form.querySelector('[data-guest-login-btn]');
  if (!isGuestLogin) return;

  // console.log('ゲストログイン_ローディング'); // (home_pages/_home) Stimulus なし
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
});
