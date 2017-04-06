var webpack = require('webpack'),
    path = require('path'),
    HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: {
        goods: path.join(__dirname, 'src/pages/goods/index.js'),
        pay: path.join(__dirname, 'src/pages/pay/index.js')
    },
    output: {
        path: path.join(__dirname, 'dist'),
        publicPath: '/dist',
        filename: 'js/[name].js'
    },
    module: {
        loaders: [{
            test: /\.html$/,
            loader: 'raw-loader'
        }, {
            test: /\.js$/,
            exclude: /node_modules/,
            loader: 'babel-loader'
        }, {
            test: /\.(png|jpg|gif)$/,
            loader: 'url-loader?limit=8192&name=./images/[hash].[ext]'
        }]
    },
    plugins: [
        new webpack.ProvidePlugin({
            $: 'jquery'
        }),
        new webpack.optimize.CommonsChunkPlugin({
            name: 'vendors',
            chunks: ['goods', 'pay']
        }),
        new HtmlWebpackPlugin({
            template: path.join(__dirname, 'src/pages/goods/goods.html'),
            filename: 'goods.html',
            inject: true,
            hash: true,
            chunks: ['vendors', 'goods']
        }),
        new HtmlWebpackPlugin({
            template: path.join(__dirname, 'src/pages/pay/pay.html'),
            filename: 'pay.html',
            inject: true,
            hash: true,
            chunks: ['vendors', 'pay']
        })
    ],
    devServer: {
        contentBase: path.join(__dirname, 'dist'),
        inline: true,
        port: 8080
    }
}
