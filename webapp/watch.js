var chokidar = require("chokidar")
  , path = require("path")
  , compiler = require("./compiler.js")
  , paths = []
  , watcher = null
  , runCompiler = null;

paths.push(path.join(__dirname, "javascripts"));
paths.push(path.join(__dirname, "less"));

watcher = chokidar.watch(paths, { usePolling: true });

runCompiler = function () {
  compiler.run(true, function (err, stats) {
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
