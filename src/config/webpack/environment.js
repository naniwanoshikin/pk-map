const { environment } = require('@rails/webpacker')

// 8 jQueryを有効にする ここないとajaxもできない
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

module.exports = environment
