// ドロップダウン stimulusは簡素化のためなし
document.addEventListener("turbo:load", () => {
  // サイドバー 横からくる
  const offcanvas = document.getElementById("offcanvasNavbar");
  // ボタン 押す所
  const toggler = document.querySelector(".custom-toggler");

  if (offcanvas && toggler) {
    // ドロワーが開き始めたら（→ ×印になる）
    offcanvas.addEventListener("show.bs.offcanvas", () => {
      toggler.setAttribute("aria-expanded", "true");
    });

    // ドロワーが閉じ始めたら （→ 3本線に戻る）
    offcanvas.addEventListener("hide.bs.offcanvas", () => {
      toggler.setAttribute("aria-expanded", "false");
    });
  }
});

// 「スマホ画面でドロワーを開き、メニュー（『PKmapとは』など）をクリックして別ページに移動して、元の画面に戻ったときに、ドロワーが開きっぱなしになったり、画面が薄暗いまま操作できなくなったりした」
// ▶︎ ページ遷移（キャッシュ保存）の直前にドロワーと薄暗い背景を即座にリセット
document.addEventListener("turbo:before-cache", () => {
  // ドロワー本体
  const offcanvasEl = document.getElementById("offcanvasNavbar");
  if (offcanvasEl) {
    // 開いた状態なら閉じる
    offcanvasEl.classList.remove("show");
    offcanvasEl.removeAttribute("aria-modal");
    offcanvasEl.removeAttribute("role");
  }

  // [×]を[三]に戻す
  const toggler = document.querySelector(".custom-toggler");
  if (toggler) {
    toggler.setAttribute("aria-expanded", "false");
  }

  // 薄暗い背景（.offcanvas-backdrop）を
  document.querySelectorAll(".offcanvas-backdrop").forEach((backdrop) => {
    backdrop.remove(); // 即座にDOMから直接削除
  });

  // bodyタグに付いたスクロール禁止スタイルなどを解除
  document.body.classList.remove("offcanvas-open");
  document.body.style.overflow = "";
  document.body.style.paddingRight = "";
});
