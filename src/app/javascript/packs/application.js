// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// グローバル登録（Bootstrap 4）
import jQuery from 'jquery';
window.$ = window.jQuery = global.jQuery = jQuery;
import IScroll from 'iscroll';
window.IScroll = global.IScroll = IScroll;


import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "@hotwired/turbo-rails" // rails7.1

// 起動
ActiveStorage.start()

// webpack
import 'bootstrap'
import { Modal } from "bootstrap"
import '../stylesheets/application.scss'
import './src/dropdown'
import './src/guest_login'
// import './src/star_review'
import "../controllers" // Rails7 Stimulus(C)

// 画像の読み込み (home/about)
require.context("../images", true);

// console.log("application.jsです");


// modal_closer_controller.js
// ブラウザの「戻る・進む」用にページがキャッシュされる直前にモーダルを閉じる
// 「Turbo がページをキャッシュする直前（turbo:before-cache イベント）に、開いているモーダルを強制的に閉じてお片付けする」という処理
document.addEventListener("turbo:before-cache", () => {
  // 1. 開いているモーダルがあれば閉じる
  document.querySelectorAll(".modal.show").forEach((modalEl) => {
    const modal = Modal.getInstance(modalEl)
    if (modal) {
      modal.hide()
    } else {
      modalEl.classList.remove("show")
      modalEl.style.display = "none"
    }
  })

  // 2. 残っている薄暗い背景やbodyのスクロール固定を解除する
  document.querySelectorAll(".modal-backdrop").forEach((el) => el.remove())
  document.body.classList.remove("modal-open")
  document.body.style.removeProperty("overflow")
  document.body.style.removeProperty("padding-right")
})