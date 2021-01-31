const path = require("path");
const outputPath = path.resolve(__dirname, "dist");

module.exports = {
  entry: "./src/dev.js",
  mode: "development",
  output: {
    filename: "dev.js",
    path: outputPath,
  },
};
