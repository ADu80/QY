// JavaScript Document
function getQueryString() {
    var result = location.search.match(new RegExp("[\?\&][^\?\&]+=[^\?\&]+", "g"));
    if (!result) return {};
    for (var i = 0; i < result.length; i++) {
        result[i] = result[i].substring(1);
    }
    var oo = {};
    for (var i in result) {
        var ss = result[i].split('=');
        oo[ss[0]] = ss[1];
    }
    return oo;
}

var dd = (function ($) {
    //var url = 'http://117.78.46.33:8057/api';
    var url = 'http://localhost:55555/api';
    function doAjax(uri, method, data, succFunc, errFunc) {
        var option = {
            url: url + (uri.substring(0, 1) === '/' ? uri : '/' + uri),
            method: method,
            dataType: 'jsonp',
            jsonp: 'jsonpcb',
            success: succFunc,
            error: errFunc
        }
        if (data) {
            option['data'] = data;
        }
        $.ajax(option);
    }
    return {
        Get: function (uri, data, succFunc, errFunc) {
            doAjax(uri, 'GET', data, succFunc, errFunc);
        },
        Post: function (uri, data, succFunc, errFunc) {
            doAjax(uri, 'POST', data, succFunc, errFunc);
        }
    }
})(jQuery);

function htmlEncode(str) {
    var ele = document.createElement('span');
    ele.appendChild(document.createTextNode(str));
    return ele.innerHTML;
}

function htmlDecode(str) {
    var ele = document.createElement('span');
    ele.innerHTML = str;
    return ele.textContent;
}

function getBoxSize(dom, sizeType) {
    var size = 0;
    if (sizeType == 'height') {
        size = $(dom).outerHeight() + parseFloat($(dom).css('marginTop')) + parseFloat($(dom).css('marginBottom'));
    }
    else if (sizeType == 'width') {
        size = $(dom).outerWidth() + parseFloat($(dom).css('marginLeft')) + parseFloat($(dom).css('marginRight'));
    }
    else {
        size = 0;
    }
    return size;
}