import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [
    "triggerContainer", // ⭐︎⭐︎⭐︎⭐︎⭐︎ 開く前 div箱（トリガー）
    "triggerStar", // ⭐︎⭐︎⭐︎⭐︎⭐︎ 開く前 span
    "modalStar", // ⭐︎⭐︎⭐︎⭐︎⭐︎ くり抜き状態 span
    "hiddenScore", // ★★☆☆☆ f.hidden_field
    "ratingValue", // '2' 評価の数値 span
    "modal", // モーダル本体 id="exampleModal"
    "form" // フォーム自体 #exampleModal
  ]

  connect() {
    // this.hiddenScoreTarget: document.getElementById("hidden_score")の代わり
    this.selectedScore = Number(this.hiddenScoreTarget.value) || 0
    this.updateStars(this.selectedScore)
    this.setupModalFocusFix()
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
  reset() {
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

  // 指定されたスコアまで塗りつぶす共通処理
  renderStars(starElements, score) {
    starElements.forEach((star, index) => {
      if (index < score) {
        star.classList.remove("far")
        star.classList.add("fas")
      } else {
        star.classList.add("far")
        star.classList.remove("fas")
      }
    })
  }


  // =======================================================
  // ⭐︎⭐︎⭐︎⭐︎⭐︎ ブラウザのアクセシビリティ警告（aria-hidden）
  // =======================================================
  setupModalFocusFix() {
    // このモーダル内部にて
    // まだBootstrap 4 (jQueryあり) の間は $() 経由でイベントを拾う必要がある
    if (window.jQuery) {
      // 1. モーダルが閉じ始める瞬間 hide
      window.jQuery(this.modalTarget).on("hide.bs.modal", () => {
        // 現在ブラウザでフォーカスが当たっている要素([×]or[閉じる])があれば
        const activeEl = document.activeElement
        if (activeEl && this.modalTarget.contains(activeEl)) {
          // フォーカスを解除
          activeEl.blur()
        }
      })

      // 2. モーダルが閉じ終わった瞬間 hidden
      window.jQuery(this.modalTarget).on("hidden.bs.modal", () => {
        if (this.hasTriggerContainerTarget) {
          // 元の画面★★☆☆☆にフォーカスを戻す
          this.triggerContainerTarget.focus()
        }
      })
    }
  };
}
