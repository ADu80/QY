webpackJsonp([0],[
/* 0 */,
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function($) {

Object.defineProperty(exports, "__esModule", {
    value: true
});

exports.default = function () {
    var win = $(window),
        winWidth = win.width(),
        fontSize = winWidth / 30;
    document.body.fontSize = fontSize > 12 ? fontSize : 12;
};
/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function($) {

Object.defineProperty(exports, "__esModule", {
    value: true
});

exports.default = function (id, data) {
    var tmpl = '' + data.map(function (d) {
        return '\n        <section class="good-group">\n            <h1>' + d.title + '</h1>\n            <ul>\n                ' + d.rows.map(function (r) {
            return '\n                    <li>\n                        <a class="good-item" href="./pay.html?id=' + r.GoodID + '">\n                            <img src="' + r.ImgUrl + '"></img>\n                            <dl class="good-info">\n                            \t<dt><p class="title">Apple MacBook Pro 13.3\u82F1\u5BF8\u7B14\u8BB0\u672C\u7535\u8111 \u6DF1\u7A7A\u7070\u8272</p></dt>\n                            \t<dt><i class="price">' + r.Price + '</i><dt>\n                            </dl>\n                        </a>\n                    </li>';
        }).join('') + '\n            </ul>\n        </section>\n    ';
    }).join('');
    $(id).append(tmpl);
};
/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 3 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 4 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


__webpack_require__(4);

__webpack_require__(3);

var _common = __webpack_require__(1);

var _common2 = _interopRequireDefault(_common);

var _goods = __webpack_require__(2);

var _goods2 = _interopRequireDefault(_goods);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// var $ = jQuery = require('jquery');

(0, _common2.default)();

var data = [{
    title: 'Hot',
    rows: [{ GoodID: '001', ImgUrl: './images/1002.png', Price: 50 }, { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 }, { GoodID: '003', ImgUrl: './images/4003.png', Price: 50 }]
}, {
    title: '3C',
    rows: [{ GoodID: '001', ImgUrl: './images/1002.png', Price: 50 }, { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 }, { GoodID: '003', ImgUrl: './images/4003.png', Price: 50 }]
}];

(0, _goods2.default)('#good-list', data);

/***/ })
],[5]);