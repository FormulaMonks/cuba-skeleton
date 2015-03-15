var compiler = require("./compiler.js");

compiler.run(false, function (err, stats) {
  if (err) {
    process.stderr.write("A fatal error ocurred.");
    process.exit(1);
  }
  else {
    console.log(stats.toString({
      chunkModules: true,
      exclude: [
        /node_modules[\\\/]react(-router)?[\\\/]/
      ],
      colors: true
    }));

    if (stats.compilation.errors.length > 0) {
      process.exit(1);
    }
  }
});
