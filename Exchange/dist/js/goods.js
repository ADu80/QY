webpackJsonp([0],[
/* 0 */,
/* 1 */,
/* 2 */,
/* 3 */,
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function($) {

Object.defineProperty(exports, "__esModule", {
    value: true
});
exports.fit = fit;
function fit() {
    var win = $(window),
        winWidth = win.width(),
        fontSize = winWidth / 30;
    document.body.fontSize = fontSize > 12 ? fontSize : 12;
}
/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function($) {

Object.defineProperty(exports, "__esModule", {
    value: true
});
exports.initData = undefined;

var _ajax = __webpack_require__(9);

var _bluebird = __webpack_require__(1);

var _bluebird2 = _interopRequireDefault(_bluebird);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var createGoods = function createGoods(id, data) {
    var tmpl = '' + data.map(function (d) {
        return '\n        <section class="good-group">\n            <h1>' + d.title + '</h1>\n            <ul>\n                ' + d.rows.map(function (r) {
            return '\n                    <li>\n                        <a class="good-item clearfix" href="./pay.html?id=' + r.GoodID + '">\n                            <img src="' + r.ImgUrl + '"></img>\n                            <dl class="good-info">\n                                <dt class="title"><p>Apple MacBook Pro 13.3\u82F1\u5BF8\u7B14\u8BB0\u672C\u7535\u8111 \u6DF1\u7A7A\u7070\u8272</p></dt>\n                                <dt class="activity"></dt>\n                                <dt class="showprice"><i>' + r.Price + '</i><span class="iconfont icon-"></span><dt>\n                            </dl>\n                        </a>\n                    </li>';
        }).join('') + '\n            </ul>\n        </section>\n    ';
    }).join('');
    $(id).append(tmpl);
};

var data = [{
    title: 'Hot',
    rows: [{ GoodID: '001', ImgUrl: './images/1002.png', Price: 50 }, { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 }, { GoodID: '003', ImgUrl: './images/1007.png', Price: 50 }]
}, {
    title: '3C',
    rows: [{ GoodID: '001', ImgUrl: './images/1002.png', Price: 50 }, { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 }, { GoodID: '003', ImgUrl: './images/4003.png', Price: 50 }]
}];

var getGoods = function getGoods() {
    // fetchData('/goods')

    return new _bluebird2.default(function (resolve, reject) {
        return setTimeout(resolve, 500, data);
    });
};

var initData = exports.initData = function initData() {
    getGoods().then(function (data) {
        createGoods('#good-list', data);
    });
};
/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 6 */,
/* 7 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 8 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function($) {

Object.defineProperty(exports, "__esModule", {
    value: true
});
exports.fetchData = fetchData;
exports.postData = postData;

var _bluebird = __webpack_require__(1);

var _bluebird2 = _interopRequireDefault(_bluebird);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var API_URL = 'http://localhost:8038/api';

function fetchData(url) {
    return new _bluebird2.default(function (resolve, reject) {
        $.get(url).done(function (res) {
            resolve(res);
        }).error(function (err) {
            reject(err);
        });
    });
}

function postData(url, data) {
    return new _bluebird2.default(function (resolve, reject) {
        $.post(url, { dataType: 'json', data: data }).done(function (res) {
            resolve(res);
        }).error(function (err) {
            reject(err);
        });
    });
}
/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


__webpack_require__(7);

var _fit = __webpack_require__(4);

__webpack_require__(8);

var _goods = __webpack_require__(5);

// var $ = jQuery = require('jquery');

(0, _fit.fit)();
(0, _goods.initData)();

/***/ })
],[10]);