var webpack = require('webpack'),
    path = require('path'),
    HtmlWebpackPlugin = require('html-webpack-plugin'),
    ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
    entry: {
        index: path.join(__dirname, 'src/pages/goods/index.js'),
        // pageitem: path.join(__dirname, 'src/pageitem/index.js'),
        // pay: path.join(__dirname, 'src/pay/index.js'),
        // page: path.join(__dirname, 'src/shopcar/index.js')
    },
    output: {
        path: path.join(__dirname, 'dist'),
        publicPath: './',
        filename: 'js/[name].js'
    },
    module: {
        rules: [{
            test: /\.js$/,
            exclude: /node-modules/,
            use: 'babel-loader'
        }, {
            test: /\.css$/,
            use: ExtractTextPlugin.extract({
                fallback: 'style-loader',
                use: 'css-loader'
            })
        }, {
            //文件加载器，处理文件静态资源
            test: /\.(woff|woff2|ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
            include: [path.join(__dirname, 'src/commons/vendor')],
            use: 'file-loader?name=css/iconfont/[name].[ext]&publicPath=/'
        }]
    },
    plugins: [
        new webpack.ProvidePlugin({
            $: 'jquery'
        }),
        new ExtractTextPlugin('css/[name].css?[contenthash]'),
        new HtmlWebpackPlugin({
            template: path.join(__dirname, 'src/pages/goods/goods.html'),
            filename: 'index.html',
            inject: true,
            chunks: ['index']
        })
    ],
    devServer: {
        contentBase: path.join(__dirname, 'dist'),
        inline: true,
        port: 8080
    }
}
