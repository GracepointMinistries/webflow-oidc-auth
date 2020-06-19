const path = require('path')
const nodeExternals = require('webpack-node-externals')
const serverlessWebpack = require('serverless-webpack')

module.exports = {
  entry: serverlessWebpack.lib.entries,
  resolve: {
    extensions: ['.js', '.jsx', '.ts', '.tsx']
  },
  externals: [nodeExternals()],
  target: 'node',
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: 'ts-loader',
        exclude: /node_modules/
      }
    ]
  },
  output: {
    libraryTarget: 'commonjs2',
    path: path.join(__dirname, '.webpack'),
    filename: '[name].js'
  }
}
