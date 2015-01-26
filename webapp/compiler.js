var webpack = require("webpack")
  , ExtractTextPlugin = require("extract-text-webpack-plugin")
  , path = require("path")
  , webpackConfig = null
  , publicPath = null
  , assetsPath = null;

assetsPath = function (relativePath) {
  return path.join(__dirname, relativePath);
};

publicPath = function (relativePath) {
  return path.normalize(path.join(__dirname, "..", "public", relativePath));
};

webpackConfig = function (fileInput, fileOutput, development) {
  var plugins = []
    , isJs = fileOutput.match(/\.js$/);

  fileOutput = publicPath(fileOutput);

  if (isJs && !development) {
    // Uglify
    plugins.push(
      new webpack.optimize.UglifyJsPlugin({
        compress: {
          warnings: false
        }
      }),
      new webpack.optimize.DedupePlugin(),
      new webpack.DefinePlugin({
        "process.env": {
          NODE_ENV: JSON.stringify("production")
        }
      }),
      new webpack.NoErrorsPlugin()
    );
  }
  else {
    plugins.push(new ExtractTextPlugin(fileOutput, { allChunks: true }));
  }

  return {
    entry: assetsPath(fileInput),
    output: {
      path: "/",
      filename: isJs ? fileOutput : "/dev/null"
    },
    module: {
      loaders: [
        {
          test: /\.html$/,
          loader: ExtractTextPlugin.extract("raw-loader")
        },
        {
          test: /\.less$/,
          loader: ExtractTextPlugin.extract("raw-loader!less-loader?compress=true")
        },
        {
          test: /\.jsx$/,
          loader: "jsx-loader"
        }
      ]
    },
    plugins: plugins
  }
};

module.exports = {
  run: function (finished) {
    [
      ["less/application.less", "stylesheets/application.css"],
      ["javascripts/index.js", "javascripts/index.js"]
    ].forEach(function (filenames, i) {
      webpack(webpackConfig(filenames[0], filenames[1], true)).run(finished);
    });
  }
};
