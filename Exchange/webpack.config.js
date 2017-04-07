var webpack = require('webpack'),
    path = require('path'),
    HtmlWebpackPlugin = require('html-webpack-plugin'),
    ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
    entry: {
        goods: path.join(__dirname, 'src/pages/goods/index.js'),
        pay: path.join(__dirname, 'src/pages/pay/index.js')
    },
    output: {
        path: path.join(__dirname, 'dist'),
        publicPath: './',
        filename: 'js/[name].js'
    },
    module: {
        rules: [{
            test: /\.html$/,
            use: 'raw-loader'
        }, {
            test: /\.js$/,
            exclude: /node_modules/,
            use: 'babel-loader'
        }, {
            test: /\.(png|jpg|gif)$/,
            use: 'url-loader?limit=8192&name=./images/[hash].[ext]'
        }, {
            test: /\.css$/,
            use: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    use: 'css-loader'
                })
        }]
    },
    plugins: [
        new webpack.ProvidePlugin({
            $: 'jquery'
        }),
        new ExtractTextPlugin('css/[name].css?[contenthash]'),
        new webpack.optimize.CommonsChunkPlugin({
            name: 'vendors',
            chunks: ['goods', 'pay']
        }),
        new HtmlWebpackPlugin({
            template: path.join(__dirname, 'src/pages/goods/goods.html'),
            filename: 'index.html',
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
        port: 8080,
        hot: true
    }
}
