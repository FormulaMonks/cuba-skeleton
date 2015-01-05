var chokidar = require("chokidar")
  , path = require("path")
  , watcher = chokidar.watch(path.join(__dirname, "assets"), { usePolling: true })
  , compiler = require("./compiler.js")
  , runCompiler;

runCompiler = function () {
  compiler.run(function (err, stats) {
    if (err) {
      console.log("An error ocurred.", err);
    }
    else {
      console.log(stats.toString({
        chunkModules: true,
        exclude: [
          /node_modules[\\\/]react(-router)?[\\\/]/
        ],
        colors: true
      }));
    }
  });
};

runCompiler();
watcher.on("change", runCompiler);
