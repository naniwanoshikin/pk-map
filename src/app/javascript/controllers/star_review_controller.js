import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // (review/form)
  static targets = [
    "triggerContainer", // ⭐︎⭐︎⭐︎⭐︎⭐︎ モーダル開く前 div
    "triggerStar", // ⭐︎⭐︎⭐︎⭐︎⭐︎ モーダル開く前 span
    "modalStar", // ⭐︎⭐︎⭐︎⭐︎⭐︎ くり抜き状態 span
    "hiddenScore", // ★★☆☆☆ f.hidden_field
    "ratingValue", // '2' 評価値 span
    "modal", // モーダル開いた後 全体 id="exampleModal"
    "form" // モーダル開いた後 form_with
  ]

  connect() {
    // this.hiddenScoreTargetとは document.getElementById("hidden_score")の代わり 上記にTargetをつける
    this.selectedScore = Number(this.hiddenScoreTarget.value) || 0
    this.updateStars(this.selectedScore)
  }

  // 1. モーダルを開く前の星をクリックした時
  selectFromOutside(event) {
    const score = Number(event.currentTarget.dataset.score)
    this.applyScore(score)
  }

  // 2. モーダル内の星にマウスを乗せた時（プレビュー表示）
  hover(event) {
    const hoverScore = Number(event.currentTarget.dataset.value)
    this.renderStars(this.modalStarTargets, hoverScore)
  }

  // 3. モーダル内の星からマウスが離れた時（確定済みの星数に戻す）
  resetPreview() {
    this.updateStars(this.selectedScore)
  }

  // 4. モーダル内の星をクリックした時（確定）
  selectInside(event) {
    const score = Number(event.currentTarget.dataset.value)
    this.applyScore(score)
  }

  // スコアの保存と表示の同期
  applyScore(score) {
    this.selectedScore = score
    this.hiddenScoreTarget.value = score
    this.ratingValueTarget.textContent = score
    this.updateStars(score)
  }

  // モーダル内外の星を一括更新
  updateStars(score) {
    this.renderStars(this.modalStarTargets, score)
    this.renderStars(this.triggerStarTargets, score)
  }

  // 共通処理: 指定されたスコアまで塗りつぶす
  renderStars(starElements, score) {
    starElements.forEach((star, index) => {
      const isFilled = index < score
        star.classList.toggle("fas", isFilled)
        star.classList.remove("far", isFilled)
    })
  }

  // Turboのフォーム送信完了時の処理 成功時のみreset
  onSubmitEnd(event) {
    if (!event.detail.success) return

    this.formTarget.reset()
    this.applyScore(0)
    if (this.hasErrorsTarget) {
      this.errorsTarget.innerHTML = ""
    }
  }




  // ============================================
  // ブラウザのアクセシビリティ警告（aria-hidden）
  // ============================================
  // モーダル内部にて
  // 1. モーダルが閉じ始める瞬間 hide
  onModalHide() {
    // 現在ブラウザでフォーカスが当たっている要素([×]or[閉じる])
    const activeEl = document.activeElement
    if (activeEl && this.modalTarget.contains(activeEl)) {
      // フォーカスを解除
      activeEl.blur()
    }
  }

  // 2. モーダルが閉じ終わった瞬間 hidden
  onModalHidden() {
    // 開く前 data-star-review-target="triggerContainer"
    if (this.hasTriggerContainerTarget) {
      // 元の画面★★☆☆☆にフォーカスを戻す
      this.triggerContainerTarget.focus()
    }
  }
}
