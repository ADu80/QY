// 对Date的扩展，将 Date 转化为指定格式的String
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
// 例子： 
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "H+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
String.prototype.trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.ltrim = function () {
    return this.replace(/(^\s*)/g, "");
}
String.prototype.rtrim = function () {
    return this.replace(/(\s*$)/g, "");
}

/********************
avalon模版方法
********************/
function heredoc(fn) {
    return fn.toString().replace(/^[^\/]+\/\*!?\s?/, '').
            replace(/\*\/[^\/]+$/, '').trim().replace(/>\s*</g, '><')
}

/********************
复制到剪切板
********************/
function copyToClipboard(elem) {
    var targetId = "_hiddenCopyText_";
    var isInput = elem.tagName === "INPUT" || elem.tagName === "TEXTAREA";
    var origSelectionStart, origSelectionEnd;
    if (isInput) {
        // 如果是input标签或textarea，则直接指定该节点
        target = elem;
        origSelectionStart = elem.selectionStart;
        origSelectionEnd = elem.selectionEnd;
    } else {
        // 如果不是，则使用节点的textContent
        target = document.getElementById(targetId);
        if (!target) {
            //如果不存在，则创建一个
            var target = document.createElement("textarea");
            target.style.position = "absolute";
            target.style.left = "-9999px";
            target.style.top = "0";
            target.id = targetId;
            document.body.appendChild(target);
        }
        target.textContent = elem.textContent;
    }
    // 聚焦目标节点，选中它的内容
    var currentFocus = document.activeElement;
    target.focus();
    target.setSelectionRange(0, target.value.length);

    // 进行复制操作
    var succeed;
    try {
        succeed = document.execCommand("copy");
    } catch (e) {
        succeed = false;
    }
    // 不再聚焦
    if (currentFocus && typeof currentFocus.focus === "function") {
        currentFocus.focus();
    }

    if (isInput) {
        // 清空临时数据
        elem.setSelectionRange(origSelectionStart, origSelectionEnd);
    } else {
        // 清空临时数据
        target.textContent = "";
    }
    return succeed;
}

/**************************************
avalon过滤器 - 金额转换成万、亿显示
***************************************/
avalon.filters.formatMoney = function (value) {
    if (!isNaN(value)) {
        if (Math.abs(value) >= 100000000) {
            value = Math.floor(value / 100000000 * 100) / 100 + '亿';
        }
        else if (Math.abs(value) >= 10000) {
            value = Math.floor(value / 10000 * 100) / 100 + '万';
        }
    }
    return value;
}

var Du = (function ($) {
    var url = '/ajaxControllers.ashx?controller=#controller#&type=#type#';
    function createOption(method, controller, type, querystring, dataType, data, todoFunc, errFunc, isloading) {
        var loading;
        if (isloading) {
            loading = $.loading('正在加载数据，请稍后...', '.viewpage');
        }
        var option = {};
        var newurl = url.replace('#controller#', controller).replace('#type#', type);
        if (querystring) {
            querystring = querystring.substring(0, 1) === '&' ? querystring : '&' + querystring;
            newurl += querystring;
        }
        option['url'] = newurl;
        option['method'] = method;
        if (dataType) {
            option['dataType'] = dataType;
        }
        if (data) {
            option['data'] = data;
        }
        option['success'] = function (data) {
            if (loading) {
                loading.close();
            }
            MessageBox.success(data);
            if (todoFunc) {
                todoFunc(data);
            }
        };
        option['error'] = function () {
            if (errFunc) {
                errFunc();
            }
            if (loading) {
                loading.close();
            }
            MessageBox.error(err.responseText);
        };
        return option;
    }
    return {
        Get: function (controller, type, querystring, todoFunc) {
            var option = createOption('GET', controller, type, querystring, null, null, todoFunc, null, false);
            $.ajax(option);
        },
        Loading: function (controller, type, querystring, todoFunc) {
            var option = createOption('GET', controller, type, querystring, null, null, todoFunc, null, true);
            $.ajax(option);
        },
        GetByData: function (controller, type, querystring, data, todoFunc) {
            var option = createOption('GET', controller, type, querystring, null, data, todoFunc, null, false);
            $.ajax(option);
        },
        LoadingByData: function (controller, type, querystring, data, todoFunc) {
            var option = createOption('GET', controller, type, querystring, null, data, todoFunc, null, true);
            $.ajax(option);
        },
        Post: function (controller, type, querystring, todoFunc) {
            var option = createOption('POST', controller, type, querystring, null, null, todoFunc, null, false);
            $.ajax(option);
        },
        PostEx: function (controller, type, querystring, todoFunc, errFunc) {
            var option = createOption('POST', controller, type, querystring, null, null, todoFunc, errFunc, false);
            $.ajax(option);
        },
        PostData: function (controller, type, querystring, data, todoFunc) {
            var option = createOption('POST', controller, type, querystring, null, data, todoFunc, null, false);
            $.ajax(option);
        },
        PostFormData: function (controller, type, querystring, data, todoFunc) {
            var option = createOption('POST', controller, type, querystring, 'json', data, todoFunc, null, false);
            $.ajax(option);
        }
    }
})(jQuery);

avalon.effect('slide', {
    enter: function (el, done) {
        $(el).slideDown();
    },
    leave: function (el, done) {
        $(el).slideUp();
    }
});

//编辑页面弹出框
avalon.effect('dialog', {
    enter: function (el, done) {
        $(el).animate({ width: 0, height: 0 }, 300, function () {
            $(el).hide();
            if (done) {
                done();
            }
        });
    },
    leave: function (el, done) {
        $(el).show();
        $(el).animate({ width: '50em', height: '40em' }, 300, done);
    }
});

avalon.effect('reportdialog', {
    enter: function (el, done) {
        $(el).animate({ width: 0, height: 0 }, 300, function () {
            $(el).hide();
            if (done) {
                done();
            }
        });
    },
    leave: function (el, done) {
        $(el).show();
        $(el).animate({ width: '96%', height: '96%' }, 300, done);
    }
});

avalon.effect('spreadsumdialog', {
    enter: function (el, done) {
        $(el).animate({ width: 0, height: 0 }, 300, function () {
            $(el).hide();
            if (done) {
                done();
            }
        });
    },
    leave: function (el, done) {
        $(el).show();
        $(el).animate({ width: '70%', height: '75%' }, 300, done);
    }
});

//编辑页面弹出框 - 小框
avalon.effect('smalldialog', {
    enter: function (el, done) {
        $(el).animate({ width: 0, height: 0 }, 300, function () {
            $(el).hide();
            if (done) {
                done();
            }
        });
    },
    leave: function (el, done) {
        $(el).show();
        $(el).animate({ width: '40em', height: '20em' }, 300, done);
    }
});


//编辑页面弹出框 - 小框
avalon.effect('pwddialog', {
    enter: function (el, done) {
        $(el).animate({ width: 0, height: 0 }, 300, function () {
            $(el).hide();
            if (done) {
                done();
            }
        });
    },
    leave: function (el, done) {
        $(el).show();
        $(el).animate({ width: '30em', height: '10em' }, 300, done);
    }
});




