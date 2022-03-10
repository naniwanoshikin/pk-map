// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// 起動
Rails.start()
Turbolinks.start()
ActiveStorage.start()

// 8
require("jquery")
import "bootstrap"

// 直上の jquery 読み込み
// require("post.js")
