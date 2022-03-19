// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// 起動
Rails.start()
ActiveStorage.start()
// Turbolinks.start() // googlemap api script再読み込み防止

// webpack
import 'bootstrap'
import '../stylesheets/application.scss'

// (V)で画像を読み込む (home/about)_image_pack_tag
require.context("../images", true);

// console.log('a')
