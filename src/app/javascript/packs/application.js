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

// 8
require("jquery")
import "bootstrap"

// 読み込み ★★☆☆☆
// require("comment.js")

// import "../styles/application.scss"
