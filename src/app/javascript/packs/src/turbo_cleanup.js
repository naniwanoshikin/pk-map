import * as bootstrap from "bootstrap"

// Turbo がブラウザの「戻る・進む」などでページ移動の（キャッシュする）直前に、
document.addEventListener("turbo:before-cache", () => {
  // 「スマホ画面でドロワーを開き、メニュー（『PKmapとは』など）を選択して別ページに移動後、元の画面に戻ったときに、ドロワーが開きっぱなしになったり、画面が薄暗いまま操作できなくなったりした」為、初期状態（閉じている状態）にリセットする処理を実施

  // モーダル・ドロワー共通 開いた時に出る見た目(HTML)をリセット
  const resetElementState = (el, isModal = false) => {
    // デベロッパーツールで要素を見ると理解できた
    el.classList.remove("show")
    el.removeAttribute("aria-modal")
    el.removeAttribute("role")
    // モーダル追加処理
    if (isModal) {
      el.style.display = "none"
      el.setAttribute("aria-hidden", "true")
    }
  }

  // 1. モーダルの裏側（記憶）と見た目（HTML）をリセット
  // <div id="exampleModal" class="modal fade show" aria-modal="true" roll="dialog" style="display: block;" ほか>
  document.querySelectorAll(".modal").forEach((modalEl) => {
    // console.log('モーダルを閉じる')
    // 「このモーダルはすでに開いている状態だ」という古い記憶が残ったままになるため、クリックしても「もう開いているから何もしなくていいや」と無視されてしまった為、裏側(JavaScript)の記憶も破棄（進むボタン後に再起動できるようにする）
    bootstrap.Modal.getInstance(modalEl)?.dispose()
    resetElementState(modalEl, true)
  })

  // 2. ドロワー（横から出るサイド）の裏側（記憶）と見た目（HTML）をリセット
  // <div class="offcanvas offcanvas-end show" tabindex="-1" id="offcanvasNavbar" data-initialized="true" aria-modal="true" role="dialog">
  document.querySelectorAll(".offcanvas").forEach((offcanvasEl) => {
    // console.log('ドロワーを閉じる')
    bootstrap.Offcanvas.getInstance(offcanvasEl)?.dispose()
    resetElementState(offcanvasEl, false)
  })

  // 3. ドロワーのみ: 開閉ボタン [×]を[三]に戻す 初期状態に戻す
  document.querySelectorAll(".custom-toggler").forEach((toggler) => {
    toggler.setAttribute("aria-expanded", "false")
  })

  // 以下、モーダル・ドロワー共通処理

  // 4. 薄暗い背景を削除
  // <div class="modal-backdrop fade show">
  document.querySelectorAll(".modal-backdrop, .offcanvas-backdrop").forEach((el) => el.remove())

  // 5. ページ全体 <body style="overflow: hidden; padding-right: 0px;"> に勝手に追加されたスクロール固定を解除
  document.body.classList.remove("modal-open", "offcanvas-open")
  document.body.style.removeProperty("overflow")
  document.body.style.removeProperty("padding-right")

})