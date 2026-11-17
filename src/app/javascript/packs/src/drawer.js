// console.log('スマホ時のみ ドロワー 3本線 or [×]')

// document ＝ 管理人室 / offcanvasNavbar = サイドバー / custom-toggler 3本線 or [×]
// ドロワーが開き始めたら（→ [×]になる）
document.addEventListener("show.bs.offcanvas", (event) => {
  if (event.target.id === "offcanvasNavbar") {
    document.querySelector(".custom-toggler")?.setAttribute("aria-expanded", "true");
  }
});

// ドロワーが閉じ始めたら （→ 3本線になる）
document.addEventListener("hide.bs.offcanvas", (event) => {
  if (event.target.id === "offcanvasNavbar") {
    document.querySelector(".custom-toggler")?.setAttribute("aria-expanded", "false");
  }
});
