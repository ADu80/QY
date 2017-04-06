webpackJsonp([1],[
/* 0 */,
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function($) {

// var $ = jQuery = require('jquery');

function createGoods(id, data) {
    var tmpl = '' + data.map(function (d) {
        return '\n        <section>\n            <h3>' + d.title + '</h3>\n            <ul>\n                ' + d.rows.map(function (r) {
            return '\n                    <li>\n                        <a href="./pay.html?id=' + r.GoodID + '">\n                            <img>' + r.ImgUrl + '</img>\n                            <i>' + r.Price + '</i>\n                        </a>\n                    </li>';
        }).join('') + '\n            </ul>\n        </section>\n    ';
    }).join('');
    console.log(tmpl);
    $(id).append(tmpl);
}

var data = [{
    title: 'Hot',
    rows: [{ GoodID: '001', ImgUrl: './images/1002.png', Price: 50 }, { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 }, { GoodID: '003', ImgUrl: './images/4003.png', Price: 50 }]
}, {
    title: '3C',
    rows: [{ GoodID: '001', ImgUrl: './images/1002.png', Price: 50 }, { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 }, { GoodID: '003', ImgUrl: './images/4003.png', Price: 50 }]
}];
createGoods('goods-box', data);
/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ })
],[1]);