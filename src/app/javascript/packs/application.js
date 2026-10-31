// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// jQueryのグローバル登録（Bootstrap 4やGoogle Maps API, スクリプトのために維持）
import jQuery from 'jquery';
window.$ = window.jQuery = global.jQuery = jQuery;
import IScroll from 'iscroll';
window.IScroll = global.IScroll = IScroll;
import 'jquery-drawer';


import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// 起動
Rails.start()
ActiveStorage.start()

// webpack
import 'bootstrap'
import '../stylesheets/application.scss'
import './src/flash'
import './src/guest_login'
import './src/map_home'
import './src/map_show'
import './src/star_review'

// 画像の読み込み (home/about)
require.context("../images", true);

// console.log('application.js 読み込みok')
