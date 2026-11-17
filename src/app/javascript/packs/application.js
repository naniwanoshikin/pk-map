// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// import jQuery from 'jquery'; // 廃止済

import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "@hotwired/turbo-rails" // rails7.1

// 起動
ActiveStorage.start()

// webpack
import "bootstrap"
import '../stylesheets/application.scss'
import './src/drawer'
import './src/guest_login'
import './src/turbo_cleanup'
import "../controllers" // Rails7 Stimulus(C)

// 画像の読み込み (home/about)
require.context("../images", true);

// console.log("application.jsです");
