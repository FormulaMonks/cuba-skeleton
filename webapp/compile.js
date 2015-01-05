var compiler = require("./compiler.js");

compiler.run(function (err, stats) {
  if (err) {
    process.stderr.write("An error ocurred.");
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
  }
});
