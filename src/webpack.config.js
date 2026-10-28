const path = require("path");
const webpack = require("webpack");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const RemoveEmptyScriptsPlugin = require("webpack-remove-empty-scripts");

module.exports = {
  mode: process.env.NODE_ENV === "production" ? "production" : "development",
  devtool: "source-map",
  // 💡 既存のパックファイルをそのままエントリーポイントとして指定
  entry: {
    application: "./app/javascript/packs/application.js"
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "app/assets/builds"), // Rails 7の標準出力先
  },
  module: {
    rules: [
      // 💡 Sass (.scss) をビルドして CSS として抽出する設定
      {
        test: /\.(scss|css)$/i,
        use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
      },
      // 💡 application.js内の require.context で画像をアセットとして処理する設定
      {
        test: /\.(png|jpe?g|gif|svg)$/i,
        type: "asset/resource",
        generator: {
          filename: "images/[name][ext]"
        }
      }
    ],
  },
  resolve: {
    extensions: [".js", ".scss", ".css"],
    modules: [
      path.resolve(__dirname, "app/javascript"),
      "node_modules"
    ],
    fallback: {
      "path": require.resolve("path-browserify")
    }
  },
  plugins: [
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin({ filename: "[name].css" }),
    // 💡 jQuery / Bootstrap 4 を動作させるための自動インポート設定
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery",
      Popper: ["popper.js", "default"]
    })
  ],
  cache: {
    type: 'filesystem', // 旧 hard-source-webpack-plugin の代わりとなる高速キャッシュ
  }
};
