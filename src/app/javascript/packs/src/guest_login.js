// ゲストログイン (home_pages/_home.html.erb)

// 通常環境（Turboなし）であれば、
document.addEventListener('click', (event) => {
  // クリックされた要素（またはその親）に data-guest-login-btn があるかチェック
  const guestBtn = event.target.closest('[data-guest-login-btn]');
  if (!guestBtn) return;

  console.log('ゲストログイン ローディング');

  const div1 = document.querySelector(".first_load");
  if (div1) div1.id = 'loading';

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
