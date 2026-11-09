import { Controller } from "@hotwired/stimulus"
// (reviews/create.turbo_stream.erb)_投稿成功時
export default class extends Controller {
  connect() {
    const modalId = this.element.dataset.modalId;
    if (window.$ && modalId) {
      // console.log('モーダルお片づけ')

      // モーダルを閉じる Bootstrapのお片付け命令
      $(modalId).modal('hide'); // #exampleModal
      // Bootstrap 4 の薄暗い背景を消去
      $('.modal-backdrop').remove();

      // フォームのリセット
      // (reviews/form)_モーダル
      $("textarea").val("");
      // 星の見た目を未選択状態に
      $(".fa-star").removeClass("fas").addClass("far");
      // 星の値を評価0に
      $("#rating_value").text("0");
      // 隠しフォームの値(前回送信用の星の値)も空(0)に
      $("#hidden_score").val("");
      // 直前の失敗で出たエラーが、成功後モーダルを開いたとき残っていない様、エラーの箱の中身だけを空にする
      $("#modal_errors").empty();
    }
  }
}
