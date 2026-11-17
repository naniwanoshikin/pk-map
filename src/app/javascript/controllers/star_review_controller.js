import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 星の評価操作・フォームの状態管理
  // (review/form)より ▶︎例: hiddenScoreTarget へ
  static targets = [
    // モーダル外 ⭐︎⭐︎⭐︎⭐︎⭐︎
    "triggerContainer", // 大元 div id="openModalBtn"
    "triggerStar", // ⭐︎⭐︎⭐︎⭐︎⭐︎ span class="star_trigger"
    // モーダル内
    "modal", // 大元 div id="exampleModal"
    "errors", // エラー箇所 error_messages div id="modal_errors"
    "form", // form_with ここからが大元
    "modalStar", // ⭐︎⭐︎⭐︎⭐︎⭐︎ 変わる部分 span (親要素 div class="ratings")
    "ratingValue", // '2' 評価値 span id="rating_value"
    "hiddenScore", // ★★☆☆☆ 星の個数 f.hidden_field id="hidden_score"
  ]

  connect() {
    // this.hiddenScoreTargetとは document.getElementById("hidden_score")の代わり
    this.selectedScore = Number(this.hiddenScoreTarget.value) || 0
    this.updateStars(this.selectedScore)
  }

  // 共通処理１: スコアの反映と保存
  applyScore(score) {
    this.selectedScore = score
    this.hiddenScoreTarget.value = score
    this.ratingValueTarget.textContent = score
    this.updateStars(score)
  }

  // 共通処理２: モーダル内外の星を一括更新
  updateStars(score) {
    // モーダル内 ⭐︎⭐︎⭐︎⭐︎⭐︎ span
    this.renderStars(this.modalStarTargets, score)
    // モーダル外 ⭐︎⭐︎⭐︎⭐︎⭐︎ span
    this.renderStars(this.triggerStarTargets, score)
  }

  // 共通処理３: 指定されたスコアまで塗りつぶす
  renderStars(starElements, score) {
    starElements.forEach((star, index) => {
      // index: 0,1,2,3,4
      if (index < score) {
        // 星を塗りつぶし
        star.classList.remove("far")
        star.classList.add("fas")
      } else {
        // 星を中をくり抜き
        star.classList.add("far")
        star.classList.remove("fas")
      }
    })
  }

  // 1. モーダル外 ☆☆☆☆☆ クリックした時
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

  // 4. モーダル内 星をクリックした時（確定）
  selectInside(event) {
    const score = Number(event.currentTarget.dataset.value)
    this.applyScore(score)
  }


  // Turboのフォーム送信完了時の処理 成功時のみリセット
  onSubmitEnd(event) {
    if (!event.detail.success) return

    // フォームの入力値・隠しフォームを一括リセット
    this.formTarget.reset()
    // 評価値を0にする / ★★★★☆ ▶︎ ☆☆☆☆☆にリセット
    this.applyScore(0)
    // 直前の失敗で出たエラーがあれば、
    if (this.hasErrorsTarget) {
      // 成功後モーダルを開いたとき残っていない様、エラーの箱の中身だけを空にする
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
