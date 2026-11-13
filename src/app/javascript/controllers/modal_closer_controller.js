import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  connect() {
    // modalId: (reviews/create.turbo_stream.erb) 投稿成功時_#exampleModal (reviews/form) モーダル画面のこと
    const modal = document.querySelector(this.element.dataset.modalId)
    if (!modal) return

    // console.log('モーダルお片づけ')
    // 1. モーダルを閉じる（Bootstrap 5 標準API）
    // 薄暗い背景も消去
    Modal.getOrCreateInstance(modal).hide()

    // 2. フォームの入力値・隠しフォームを一括リセット
    modal.querySelector("form")?.reset()

    // 3. ★★★★☆ ▶︎ ☆☆☆☆☆にリセット
    modal.querySelectorAll(".fa-star").forEach(star => star.classList.replace("fas", "far"))
    // 評価値を0にする
    const rating = modal.querySelector("#rating_value")
    if (rating) rating.textContent = "0"
    // 直前の失敗で出たエラーが、成功後モーダルを開いたとき残っていない様、エラーの箱の中身だけを空にする
    const errors = modal.querySelector("#modal_errors")
    if (errors) errors.innerHTML = ""

    // 4. 役目を終えた自分自身（空のdiv）をDOMから削除して綺麗に保つ
    this.element.remove()
  }
}
