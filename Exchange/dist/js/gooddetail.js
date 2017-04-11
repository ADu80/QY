webpackJsonp([2],{

/***/ 10:
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),

/***/ 15:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__commons_basic_slideTab__ = __webpack_require__(20);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__gooddetail_mock__ = __webpack_require__(21);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__gooddetail_mock___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__gooddetail_mock__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return init; });



var onTabSlided = (e) => {

}

var initData = () => {

}


var initAction = () => {
    new __WEBPACK_IMPORTED_MODULE_0__commons_basic_slideTab__["a" /* default */]('tab-1', onTabSlided);
}

var init = () => {
    initData();
    initAction();
}


/***/ }),

/***/ 20:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function($) {function SlideTab(id, fn) {
    this.target = $('#' + id);
    this.selectedTabIndex = 0;

    var datafor = '[data-for="' + id + '"]';
    this.labels = $(datafor).find('.tab-label');
    this.pages = $('#' + id).find('.tab-page');

    this.winWidth = $(window).width();

    init(this, fn);
}

var init = (ctx, fn) => {
    // ctx.pages.width(320);
    ctx.labels.click((e) => {
        var index = 0;
        if (e.target.tagName === "A") {
            index = parseInt($(e.target).parent().attr('data-i'));
        } else {
            index = parseInt($(e.target).attr('data-i'));
        }
        e.dataIndex = index;
        e.oldScrollLeft = ctx.target.scrollLeft();
        e.newScrollLeft = index * ctx.winWidth;


        slide(ctx, e, fn);
    });

    var tabcontent = ctx.target.find('.tab-content');

    ctx.pages.scroll((e) => {
        var scroLeft = ctx.target.scrollLeft();
        var i = Math.round(scroLeft / ctx.winWidth);
        e.dataIndex = i;
        e.oldScrollLeft = scroLeft;
        e.newScrollLeft = (i - 1) * ctx.winWidth;
        console.log(scroLeft);
        slide(ctx, e, fn);
    });
}

var selectTabLabel = (ctx, e) => {
    ctx.labels.eq(e.dataIndex).addClass('active');
    ctx.labels.eq(ctx.selectedTabIndex).removeClass('active');
}

var selectTabContent = (ctx, e) => {
    ctx.target.scrollLeft(e.newScrollLeft);
}

var slide = (ctx, e, fn) => {
    if (e.dataIndex === undefined || ctx.selectedTabIndex === e.dataIndex) {
        return;
    }
    selectTabLabel(ctx, e);
    selectTabContent(ctx, e);
    ctx.selectedTabIndex = e.dataIndex;
    fn(e);
}



/* harmony default export */ __webpack_exports__["a"] = (SlideTab);

/* WEBPACK VAR INJECTION */}.call(__webpack_exports__, __webpack_require__(0)))

/***/ }),

/***/ 21:
/***/ (function(module, exports) {

var good = {
    goodid: 1,
    goodname: 'Macbook Air 2014 4G内存 128GSSD硬盘',
    price: 6388
}


/***/ }),

/***/ 22:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function($) {Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__assets_iconfont_iconfont_css__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__assets_iconfont_iconfont_css___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0__assets_iconfont_iconfont_css__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__commons_css_comm_css__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__commons_css_comm_css___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__commons_css_comm_css__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__gooddetail_css__ = __webpack_require__(10);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__gooddetail_css___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__gooddetail_css__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__commons_basic_fit__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__gooddetail__ = __webpack_require__(15);







$(function(e) {
    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_3__commons_basic_fit__["a" /* default */])();
    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_4__gooddetail__["a" /* init */])();
});

/* WEBPACK VAR INJECTION */}.call(__webpack_exports__, __webpack_require__(0)))

/***/ })

},[22]);