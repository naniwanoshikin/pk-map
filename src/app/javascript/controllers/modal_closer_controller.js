import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  // (turbo_cleanup.js) とやっていることは同じ
  // 違い1: タイミング (reviews/create.turbo_stream.erb)_レビュー成功時に実行
  // 違い2: 閉じ方 ふわっとアニメーション付きで閉じる
  connect() {
    // this.element: <div data-controller="modal-closer" data-modal-id="#exampleModal"></div>のこと
    // modalId: #exampleModalのこと ▶︎ (reviews/form)_モーダル内の大元のこと
    const modal = document.querySelector(this.element.dataset.modalId)
    if (modal) {
      // console.log('turbo_streamでモーダルを閉じた')
      // モーダル本体や薄暗い背景やスクロール固定を一括で解除
      // hide(): 同じページにいるまま閉じる時に使える
      Modal.getOrCreateInstance(modal).hide()
    }
    // 役目を終えた自分自身をDOMから削除（使い捨ての指令役）
    this.element.remove()
  }
}
