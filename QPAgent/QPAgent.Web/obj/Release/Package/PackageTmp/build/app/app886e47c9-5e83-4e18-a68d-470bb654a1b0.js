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





var app = avalon.define({
    $id: 'app',
    LoginUser: { UserID: -1, UserName: '', RoleID: -1, AgentLevel: 0, AgentID: -1, RoleName: '', IsAgent: false },
    getUsersInfo: function (initcb) {
        $.ajax({
            url: '/ajaxControllers.ashx?controller=LoginInfo&type=Index',
            method: 'GET',
            success: function (data) {
                MessageBox.success(data);
                app.LoginUser = data.result.LoginInfo;
                app.SenstWords = data.result.SenstWords;
                initcb();
            },
            error: function (err) {
                MessageBox.error(err.responseText);
            }
        });
    },
    loginTime: 0,
    loginTimeStr: '',
    loginLong: 0,
    loginLongStr: '',
    getLoginTime: function () {
        var myDate = new Date();
        app.loginTime = myDate.getTime();
        app.loginTimeStr = myDate.toLocaleTimeString();
    },
    getLoginLong: function () {
        var now = new Date();    //结束时间
        var long = now.getTime() - app.loginTime;  //时间差的毫秒数
        app.loginLong = long;

        //计算出相差天数
        var days = Math.floor(long / (24 * 3600 * 1000))
        //计算出小时数
        var leave1 = long % (24 * 3600 * 1000)    //计算天数后剩余的毫秒数
        var hours = Math.floor(leave1 / (3600 * 1000))
        //计算相差分钟数
        var leave2 = leave1 % (3600 * 1000)        //计算小时数后剩余的毫秒数
        var minutes = Math.floor(leave2 / (60 * 1000))
        //计算相差秒数
        var leave3 = leave2 % (60 * 1000)      //计算分钟数后剩余的毫秒数
        var seconds = Math.round(leave3 / 1000)

        app.loginLongStr = days + "天 " + hours + "小时 " + minutes + " 分钟" + seconds + " 秒";
    },
    addLog: function (operation, operator, logContent) {
        var url = "/ajaxControllers.ashx?controller=Log&type=New";
        var formData = "Operator=" + operator + "&Operation=" + operation + "&LogContent" + LogContent;
        $.ajax({
            url: url,
            method: 'POST',
            data: formData,
            success: function (data) {
                MessageBox.success(data);
            },
            error: function (err) {
                MessageBox.error(err.responseText);
            }
        })
    },
    setButtonDisabled: function (disabled) {
        $('button').attr('disabled', disabled);
        $('a').attr('disabled', disabled);
    },
    loginInfoListBoxVisible: false,
    changePwdDialogVisible: false,
    openLoginInfoListBox: function () {
        app.loginInfoListBoxVisible = true;
    },
    closeLoginInfoListBox: function () {
        app.loginInfoListBoxVisible = false;
    },
    openChangePwdDialog: function () {
        $('div.login-info-pwd').find('input').eq(0).focus();
        app.changePwdDialogVisible = true;
    },
    closeChangePwdDialog: function () {
        app.changePwdDialogVisible = false;
    },
    PwdForm: { UserID: -1, oldPwd: '', newPwd: '', cfmPwd: '' },
    changePwd: function (e) {
        if (app.PwdForm.newPwd.trim() === '') {
            alert("密码不能为空！");
            return false;
        }
        if (app.PwdForm.newPwd !== app.PwdForm.cfmPwd) {
            alert("新密码与确认密码不一致！");
            return false;
        }
        $.ajax({
            url: '/ajaxControllers.ashx?controller=SubAgents&type=Edit&subType=ch_pwd2',
            method: 'POST',
            data: $(e.target).serialize(),
            success: function (data) {
                if (data.status === 'success') {
                    app.PwdForm = { UserID: -1, oldPwd: '', newPwd: '', cfmPwd: '' }
                    app.toggleChangePwdDialog();
                }
                MessageBox.show(data);
            },
            error: function (err) {
                MessageBox.error(data);
            }
        });
    },
    hideLoginInfoListBox: function (e, el) {
        var eprop = $(e.target).prop('className');
        if (eprop.indexOf(el) == -1) {
            app.loginInfoListBoxVisible = false;
        }
    },
    SenstWords: [],
    IsSenstWord: function (e) {
        var word = e.target.value;
        var iss = false;
        var len = word.length;
        var stws = app.SenstWords.$model;
        for (var s in stws) {
            var sw = stws[s].SensitiveWord;
            if (word.match(new RegExp(sw))) {
                iss = true;
            }
        }
        if (iss) {
            $(e.target).after('<span style="padding-left:1em;color:red;">输入字符不符合规定</span>');
            setTimeout(function () {
                $(e.target).next().remove();
            }, 5000);
            e.target.value = '';
            e.target.focus();
        }
    },
    init: function (initcb) {
        app.getUsersInfo(initcb);
        app.getLoginTime();
    }
});
setInterval(function () {
    app.getLoginLong();
}, 1000);


(function () {
    function initcb() {
        //if (!app.LoginUser.IsAgent) {
        //    vmadmin.init();
        //    vmroles.init();
            vmspreaderoptions.init();
        //    vmsensitiveword.init();
        //}
        vmMenu.init();
        vmInfo.init();
        //vmsubagentlist.init();
        //vmlog.init();
    }
    app.init(initcb);
})();
var ArrayState = (function () {
    function indexOf(arr, ele) {
        for (var i = 0, len = arr.length; i < len; i++) {
            if (arr[i] === ele) {
                return i;
            }
        }
        return -1;
    }
    return {
        indexOf: indexOf
    }
})();
$.loading = function (param, parentDom) {
    var option = $.extend({
        id: 'loading',      //唯一标识
        parent: parentDom,     //父容器
        msg: ''             //提示信息

    }, param || {});
    var obj = {};
    var html = '<table id=' + option.id + ' class="loading">' +
                    '<tr>' +
                        '<td>' +
                            '<div class="circle">' +
                            '</div>' +
                            '<div class="circle1">' +
                            '</div>';
    if (param) {
        html += '<div class="msg"><p class="shine">' + param + '</p></div>';
    }
    html += '</td></tr></table>';
    var loading = $(html).appendTo(option.parent);

    return {
        play: function () {
            $('.circle,.circle1,.shine', loading).toggleClass('stop');
        },
        pause: function () {
            $('.circle,.circle1,.shine', loading).toggleClass('stop');
        },
        close: function () {
            loading.remove();
        }
    };
};

var MessageBox = (function () {
    var canAlert = true;
    return {
        show: function (data) {
            if (data.status == 'success') {
                alert(data.message);
            }
            else{
                alert(data.message);
            }
            if (data.expire) {
                window.location.href = '/Login.aspx';
                return false;
            }
        },
        success: function (data) {
            if (data.expire) {
                if (canAlert) {
                    alert(data.message);
                    canAlert = false;
                }
                window.location.href = '/Login.aspx';
                return false;
            }
        },
        error: function (errText) {
            alert(errText);
        },
        none: function (errText) {

        }
    }
})();
var ArrayState = (function () {
    function indexOf(arr, ele, key) {
        for (var i = 0, len = arr.length; i < len; i++) {
            if (arr[i][key] === ele[key]) {
                return i;
            }
        }
        return -1;
    }
    return {
        indexOf: indexOf
    }
})();
avalon.component('ms-grid', {
    template: heredoc(function () {
        /*
        <div class="grid">
            <div class="gridview">
                <slot name="table"></slot>
                <div class="gridview-nodata" ms-visible="@datasource.length===0&&!@onsearching">暂无记录</div>
            </div>
            <div class="pager">
                <p>页码/总页数：<span class="num">{{@pageIndex}}</span>/<span class="num">{{@totalPage}}</span>每页<span class="num">{{@pageSize}}</span>行,共<span class="num">{{@totalCount}}</span>条记录</p>
                <a ms-class="['first',@firstDisabled&&'disabled']" ms-click="@gotoPage(1)">首页</a> 
                <a ms-class="['pre',@preDisabled&&'disabled']" ms-click="@gotoPage(@pageIndex-1)">上一页</a>
                <a ms-class="['next',@nextDisabled&&'disabled']" ms-click="@gotoPage(@pageIndex+1)">下一页</a>
                <a ms-class="['last',@lastDisabled&&'disabled']" ms-click="@gotoPage(@totalPage)">末页</a>
                <input type="text" ms-duplex="@goIndex">
                <a ms-click="@go()">Go</a>
            </div>
        </div>
        */
    }),
    defaults: {
        /********外部注入*****/
        //datasource: [],
        //columns: [],
        onsearching: false,
        fillGrid: function (e) {
            //由onReady调用
        },
        onpagechange: function (e) {
            //由gotoPage调用
            this.fillGrid(e);
        },
        pageIndex: 1,
        pageSize: 20,
        totalPage: 0,
        totalCount: 0,
        /********************/

        gotoPage: function (i) {
            if (i <= 0 || i == this.pageIndex || i > this.totalPage) {
                return;
            }
            var e = { pageIndex: i, pageSize: this.pageSize, cancel: false };
            this.onpagechange(e);
            if (e.cancel) return;
            this.pageIndex = i;
            this.setdisable(i);
        },
        firstDisabled: false,
        preDisabled: false,
        nextDisabled: false,
        lastDisabled: false,
        setdisable: function (i) {
            if (this.totalPage == 0 || this.totalPage == 1) {
                this.firstDisabled = true;
                this.preDisabled = true;
                this.nextDisabled = true;
                this.lastDisabled = true;
            }
            else if (i == 1) {
                this.firstDisabled = true;
                this.preDisabled = true;
                this.nextDisabled = false;
                this.lastDisabled = false;
            }
            else if (i == this.totalPage) {
                this.firstDisabled = false;
                this.preDisabled = false;
                this.nextDisabled = true;
                this.lastDisabled = true;
            }
            else if (i > 1 && i < this.totalPage) {
                this.firstDisabled = false;
                this.preDisabled = false;
                this.nextDisabled = false;
                this.lastDisabled = false;
            }
            else {
                this.firstDisabled = true;
                this.preDisabled = true;
                this.nextDisabled = true;
                this.lastDisabled = true;
            }
        },
        goIndex: 0,
        go: function () {
            this.gotoPage(this.goIndex);
        },
        vmodel: '',
        showsmartmenu: function (vmodel, cb) {
            //var contextmenu_data = [[{
            //    text: "刷新",
            //    func: function () {
            //       cb({ pageIndex: this.page, pageSize: this.pageSize });
            //    }
            //}]];
            //var option = { name: 'grid' };
            //var dom = vmodel ? vmodel + ' .grid' : '.grid';
            //$(dom).smartMenu(contextmenu_data, option);
        },

        /*********begin选择框**************/
        allchecked: false,
        setSkipChecked: function () { },
        checkAll: function (e) {
            console.log('checkAll');
            var checked = e.target.checked
            this.datasource.forEach(function (el) {
                el.checked = checked
            });
            this.setSkipChecked();
        },
        checkOne: function (e) {
            console.log('checkOne');
            var checked = e.target.checked
            if (checked === false) {
                this.allchecked = false
            } else {
                this.allchecked = this.datasource.every(function (el) {
                    return el.checked
                })
            }
        },
        /***********end选择框****************/

        onInit: function (e) {

        },
        onReady: function (e) {
            //加载数据
            var ee = { pageIndex: this.pageIndex, pageSize: this.pageSize }
            //this.fillGrid(ee);

            //右键菜单
            this.showsmartmenu(this.vmodel, this.fillGrid);
            this.setdisable(1);
        },
        onViewChange: function (e) {
            //var ee = { pageIndex: this.pageIndex, pageSize: this.pageSize }
            //this.fillGrid(ee);
            this.setdisable(this.pageIndex);
        }
    }
});
var treeID = 0
avalon.component('tree', {
    template: heredoc(function () {
        /*
        <ul>
            <li ms-for="(index, el) in @tree" ms-class="['item','item-'+el.level,'item-'+el.type]">
                <div class="title">
                    <span ms-class="el.subtree.length?(el.open?'iconfont icon-icon-copy-copy1':'iconfont icon-icon-copy-copy'):'none'" ms-click="@openSubTree(el) | stop"></span>
                    <span class="iconfont icon-ren"></span>
                    <span class="title-text" ms-click="@onTreeNodeSelected(el,$event)" ms-on-contextmenu="@onContextMenu(el,$event)">{{el.title}}</span>
                </div>
                <div ms-visible="el.open" ms-html="@renderSubTree(el)" class="subtree">
                </div>
            </li>
        </ul>
        */
    }),
    defaults: {
        //tree: [],
        renderSubTree: function (el) {
            return el.subtree.length ? '<wbr ms-widget="{is:\'tree\',$id:\'tree_' + (++treeID) + '\',tree:el.subtree,onTreeNodeSelected:@onTreeNodeSelected}" />' : '';
        },
        openSubTree: function (el) {
            el.open = !el.open;
        },
        //contextmenuArr: [],
        //showContextMenu: function (module, data) {
        //    var option = { name: 'tree' };
        //    var menudom;
        //    if (!module) {
        //        menudom = '.tree .item .title .title-text';
        //    }
        //    else {
        //        menudom = module + ' .tree .item .title .title-text';
        //    }
        //    $(menudom).smartMenu(data, option);
        //},
        //onContextMenu: function (el, e) {
        //    $('.tree .item .title').css({ background: 'transparent' });
        //    $('.lev-contextmenu').addClass("visible");
        //    $('.lev-contextmenu').css({ left: e.clientX, top: e.clientY });
        //    return false;
        //},
        onReady: function (e) {
            //this.showContextMenu(this.module, this.contextmenuArr.$model);

            $('.lev-contextmenu .item').hover(function () {
                $(this).find('.sub').addClass('visible');
            });
            $('.lev-contextmenu .item').mouseleave(function () {
                $(this).find('.sub').removeClass('visible');
            });
            $('.lev-contextmenu .sub .item .title').click(function () {
                $('.lev-contextmenu').removeClass("visible");
            });
            $('body').click(function () {
                $('.lev-contextmenu').removeClass("visible");
            });
        }
    }
});

var vmadmin = avalon.define({
    $id: 'vmadmin',
    moduleType: 3,
    condition: { keyword: '', status: -1 },
    datasource: [],
    columns: [],
    selectedRowIndex: -1,
    selectedRow: {},
    IsFind: 0,
    newModel: { UserID: -1, UserName: '', oriPassword: '', Password: '', cfPassword: '', IsBand: false, BandIP: '0.0.0.0', RoleID: -1, Nullity: 0 },
    editModel: { UserID: -1, UserName: '', oriPassword: '', Password: '', cfPassword: '', IsBand: false, BandIP: '0.0.0.0', RoleID: -1, Nullity: 0 },
    roles: [],
    changeStatus: function (e) {
        vmadmin.condition.status = e.target.value;
    },
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&keyword=' + vmadmin.condition.keyword + '&status=' + vmadmin.condition.status;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;
        Du.Loading('Admin', 'Index', querystring, function (data) {
            vmadmin.datasource = data.result.data;
            vmadmin.config.totalPage = data.result.totalPage;
            vmadmin.config.totalCount = data.result.totalCount;
            if (vmadmin.selectedRowIndex != -1) {
                vmadmin.datasource[vmadmin.selectedRowIndex].selected = true;
            }
        });
    },
    findNew: function () {
        if (vmadmin.IsFind == 0) {
            vmadmin.IsFind = 1;
            vmadmin.config.pageIndex = 1;
            vmadmin.fillGrid({ pageIndex: 1, pageSize: vmadmin.config.pageSize });
        }
    },
    find: function () {
        vmadmin.config.pageIndex = 1;
        vmadmin.fillGrid({ pageIndex: 1, pageSize: vmadmin.config.pageSize });
    },
    reset: function () {
        vmadmin.condition = { keyword: '', status: -1 };
    },
    /***********注入grid的方法**************/
    onGridSelectedRowChanged: function (i, r) {
        if (i === vmadmin.selectedRowIndex) return;

        if (vmadmin.selectedRowIndex !== -1) {
            vmadmin.datasource[vmadmin.selectedRowIndex].selected = false;
        }
        vmadmin.datasource[i].selected = true;

        vmadmin.editModel.UserID = r.UserID;
        vmadmin.editModel.UserName = r.UserName;
        vmadmin.editModel.Password = '';
        vmadmin.editModel.cfPassword = '';
        vmadmin.editModel.IsBand = r.IsBand;
        vmadmin.editModel.BandIP = r.BandIP;
        vmadmin.editModel.RoleID = r.RoleID;
        vmadmin.editModel.Nullity = r.Nullity;

        vmadmin.selectedRowIndex = i;
        vmadmin.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    clearModel: function () {
        vmadmin.newModel.UserID = -1;
        vmadmin.newModel.UserName = '';
        vmadmin.newModel.Password = '';
        vmadmin.newModel.cfPassword = '';
        vmadmin.newModel.BandIP = '0.0.0.0';
        vmadmin.newModel.IsBand = false;
        vmadmin.newModel.RoleID = -1;
        vmadmin.newModel.Nullity = 0;
    },
    /*************************************/
    closeAddDialog: function () {
        vmadmin.addAnimation = 'enter';
        vmadmin.clearModel();
        vmadmin.vmState = 'none';
    },
    closeEditDialog: function () {
        vmadmin.editAnimation = 'enter';
        vmadmin.clearModel();
        vmadmin.vmState = 'none';
    },
    closeRoleDialog: function () {
        vmadmin.roleAnimation = 'enter';
        vmadmin.clearModel();
        vmadmin.vmState = 'none';
    },
    closePwdDialog: function () {
        vmadmin.pwdAnimation = 'enter';
        vmadmin.clearModel();
        vmadmin.vmState = 'none';
    },
    vmState: 'none',
    addAnimation: 'enter',
    editAnimation: 'enter',
    roleAnimation: 'enter',
    pwdAnimation: 'enter',
    vpageChange: function (page) {
        if (page === 'add') {
            vmadmin.vmState = 'add';
            vmadmin.addAnimation = 'leave';
        }
        else if (page === 'edit') {
            if (vmadmin.selectedRowIndex == -1) {
                alert('没有选中行！');
                return false;
            }
            var sr = vmadmin.datasource.$model[vmadmin.selectedRowIndex];
            vmadmin.editModel.UserID = sr.UserID;
            vmadmin.editModel.UserName = sr.UserName;
            vmadmin.editModel.IsBand = sr.IsBand;
            vmadmin.editModel.BandIP = sr.BandIP;
            vmadmin.editModel.RoleID = sr.RoleID;
            vmadmin.vmState = 'edit';
            vmadmin.editAnimation = 'leave';
        }
        else if (page === 'ch_role') {
            if (vmadmin.selectedRowIndex == -1) {
                alert('没有选中行！');
                return false;
            }
            var sr = vmadmin.datasource.$model[vmadmin.selectedRowIndex];
            vmadmin.editModel.UserID = sr.UserID;
            vmadmin.editModel.UserName = sr.UserName;
            vmadmin.editModel.RoleID = sr.RoleID;
            vmadmin.vmState = 'ch_role';
            vmadmin.roleAnimation = 'leave';
        }
        else if (page === 'ch_pwd') {
            if (vmadmin.selectedRowIndex == -1) {
                alert('没有选中行！');
                return false;
            }
            vmadmin.vmState = 'ch_pwd';
            vmadmin.pwdAnimation = 'leave';
        }
        //vmadmin.editpage = page;
        return false;
    },
    changePwd: function () {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&subType=ch_pwd';
        querystring += '&UserID=' + vmadmin.editModel.UserID + '&UserName=' + vmadmin.editModel.UserName;

        Du.Post('Admin', 'Edit', querystring, function (data) {
            if (data.status == 'success') {
                //vmadmin.vpageBack();
                vmadmin.closePwdDialog();
            }
            MessageBox.show(data);
        });
    },
    submit: function (e) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        var type = '';
        if (vmadmin.vmState == 'add')
            type = 'New';
        else if (vmadmin.vmState == 'edit')
            type = 'Edit';
        else if (vmadmin.vmState == 'ch_role') {
            type = 'Edit';
            querystring += '&subType=' + vmadmin.vmState;
        }
        else if (vmadmin.vmState == 'ch_pwd') {
            type = 'Edit';
            querystring += '&subType=' + vmadmin.vmState;
        }
        var data = $(e.target).serialize();
        if (type == 'New') {
            var g_UserName = e.target.UserName.value;
            var g_Password = e.target.Password.value;
            var g_cfPassword = e.target.cfPassword.value;
            if (g_UserName == '') {
                alert('用户名不能为空!'); return;
            }
            if (g_Password == '') {
                alert('密码不能为空!'); return;
            }
            if (g_cfPassword != g_Password) {
                alert('确认密码不一致!'); return;
            }
        }
        if (type == 'Edit') {
            var g_UserName = e.target.UserName.value;
            if (g_UserName == '') {
                alert('用户名不能为空!'); return;
            }

        }
        Du.PostFormData('Admin', type, querystring, data, function (data) {
            if (data.status == 'success') {
                //vmadmin.vpageBack();
                switch (vmadmin.vmState) {
                    case 'add':
                        if (data.message != "用户名已经存在！") {
                            vmadmin.closeAddDialog();
                            vmadmin.find();
                        }
                        break;
                    case 'edit':
                        if (data.message != "用户名已经存在！") {
                            vmadmin.closeEditDialog();
                            vmadmin.find();
                        }
                        break;
                    case 'ch_role':
                        vmadmin.closeRoleDialog();
                        break;
                    case 'ch_pwd':
                        vmadmin.closePwdDialog();
                        break;
                }
            }
            MessageBox.show(data);
        });
    },
    getIds: function () {
        var ids = '';
        var dm = vmadmin.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i].UserID;
            }
        }
        return ids.substring(1, ids.length);;
    },
    del: function () {
        ids = vmadmin.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&ids=' + ids;
        Du.Post('Admin', 'Delete', querystring, function (data) {
            MessageBox.show(data);
            vmadmin.find();
        });
    },
    dj: function () {
        ids = vmadmin.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&subType=dj&ids=' + ids;
        Du.Post('Admin', 'Edit', querystring, function (data) {
            MessageBox.show(data);
            vmadmin.find();
        });
    },
    jd: function () {
        ids = vmadmin.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&subType=jd&ids=' + ids;
        Du.Post('Admin', 'Edit', querystring, function (data) {
            MessageBox.show(data);
            vmadmin.find();
        });

        return false;
    },
    init: function () {
        vmadmin.find();
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;

        Du.Get('Roles', 'Index', querystring, function (data) {
            MessageBox.success(data);
            var roles = data.result.data;

            for (var i in roles) {
                if (roles[i].AgentLevel == 0) {
                    vmadmin.roles.push(roles[i]);
                }
            }
        });
    },
    sortDesc: function (col) {
        if (vmadmin.selectedRowIndex !== -1) {
            vmadmin.datasource[vmadmin.selectedRowIndex].selected = false;
        }
        vmadmin.datasource.sort(function (a, b) {
            if (col == 'PreLogintime' || col == 'LastLogintime') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });
    },
    sortAsc: function (col) {
        if (vmadmin.selectedRowIndex !== -1) {
            vmadmin.datasource[vmadmin.selectedRowIndex].selected = false;
        }
        vmadmin.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'PreLogintime' || col == 'LastLogintime') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmadmin.datasource.forEach(function (el) {
            if (el.UserName !== 'admin') {
                el.checked = checked
            }
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmadmin.allchecked = false
        } else {
            vmadmin.allchecked = vmadmin.datasource.every(function (el) {
                return el.checked
            })
        }
    }

});

var vmGamerlistInfo = avalon.define({
    $id: 'vmGamerlistInfo',
    condition: { GameID: '', Accounts: '', Range: 0, startDate: '', endDate: '', userType: 'admin', byUserID: -1 },
    datasource: [],
    selectedRow: {},
    selectedRowIndex: -1,
    IsFind: 0,
    onRowChanged: function (i, r) {
        if (i === vmGamerlistInfo.selectedRowIndex) return;

        if (vmGamerlistInfo.selectedRowIndex !== -1) {
            vmGamerlistInfo.datasource[vmGamerlistInfo.selectedRowIndex].selected = false;
        }
        vmGamerlistInfo.datasource[i].selected = true;

        vmGamerlistInfo.selectedRowIndex = i;
        vmGamerlistInfo.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    fillGrid: function (e) {
        if (vmInfo.selectedTreeNode.IsAgent) {
            vmGamerlistInfo.condition.userType = 'agent';
        }
        else {
            vmGamerlistInfo.condition.userType = 'admin';
        }
        if (vmGamerlistInfo.condition.GameID && !/^\s*\d*\s*$/.test(vmGamerlistInfo.condition.GameID)) {
            alert("玩家ID只能输入数字！");
            return false;
        }
        var loading = $.loading('正在加载数据，请稍后...', '.viewpage');
        var url = '/ajaxControllers.ashx?controller=MyInfo&type=Index&subType=gamerlist';
        url += '&GameID=' + (vmGamerlistInfo.condition.GameID || '-1');
        url += '&Accounts=' + vmGamerlistInfo.condition.Accounts;
        url += '&Range=' + vmGamerlistInfo.condition.Range;
        url += '&startDate=' + vmGamerlistInfo.condition.startDate;
        url += '&endDate=' + vmGamerlistInfo.condition.endDate;
        url += '&userType=' + vmGamerlistInfo.condition.userType;
        url += '&byUserID=' + vmGamerlistInfo.condition.byUserID;
        if (e.pageIndex)
            url += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            url += '&pageSize=' + e.pageSize;
        $.ajax({
            url: url,
            method: 'GET',
            success: function (data) {
                loading.close();
                MessageBox.success(data);
                vmGamerlistInfo.datasource.clear();
                vmGamerlistInfo.datasource = data.result.data;
                vmGamerlistInfo.config.totalPage = data.result.totalPage;
                vmGamerlistInfo.config.totalCount = data.result.totalCount;
            },
            error: function (err) {
                loading.close();
                MessageBox.error(err.responseText);
            }
        });
        return false;
    },
    findNew: function () {
        if (vmGamerlistInfo.IsFind == 0) {
            vmGamerlistInfo.IsFind = 1;
            vmGamerlistInfo.config.pageIndex = 1;
            vmGamerlistInfo.fillGrid({ pageIndex: 1, pageSize: vmGamerlistInfo.config.pageSize });
        }
    },
    find: function () {
        vmGamerlistInfo.config.pageIndex = 1;
        vmGamerlistInfo.fillGrid({ pageIndex: 1, pageSize: vmGamerlistInfo.config.pageSize });
    },
    clearDatasource: function () {
        vmGamerlistInfo.datasource.clear();
        vmGamerlistInfo.config.totalPage = 0;
        vmGamerlistInfo.config.totalCount = 0;
    },
    clearCondition: function () {
        vmGamerlistInfo.condition.GameID = '';
        vmGamerlistInfo.condition.Accounts = '';
        vmGamerlistInfo.condition.Range = 0;
        vmGamerlistInfo.condition.startDate = '';
        vmGamerlistInfo.condition.endDate = '';
    },
    noSelfCheck: function (UserID) {
        if (UserID === vmInfo.selectedTreeNode.id && app.LoginUser.IsAgent)
            return true;
        return false;
    },
    noCheckSelf: function () {
        if (app.LoginUser.IsAgent) {
            var selfIndex = -1;
            var dm = vmGamerlistInfo.datasource;
            dm.forEach(function (el, i) {
                if (el.UserID === vmInfo.selectedTreeNode.id) {
                    selfIndex = i;
                }
            });
            if (selfIndex !== -1) {
                vmGamerlistInfo.datasource[selfIndex].checked = false;
            }
        }
    },
    getIds: function (idname) {
        var ids = '';
        var dm = vmGamerlistInfo.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i][idname];
            }
        }
        return ids.substring(1, ids.length);;
    },
    checkIds: function () {
        var ids = vmGamerlistInfo.getIds('UserID');
        return ids;
    },
    sortDesc: function (col) {
        if (vmGamerlistInfo.selectedRowIndex !== -1) {
            vmGamerlistInfo.datasource[vmGamerlistInfo.selectedRowIndex].selected = false;
        }
        vmGamerlistInfo.datasource.sort(function (a, b) {
            if (col == 'SpreaderDate') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmGamerlistInfo.selectedRowIndex !== -1) {
            vmGamerlistInfo.datasource[vmGamerlistInfo.selectedRowIndex].selected = false;
        }
        vmGamerlistInfo.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'SpreaderDate') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    maxCellWidth: 20,
    ColumnWidthObj: { checked: 2, GameID: 7, Accounts: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7 },
    getFitCellWidth: function (col, minWidth, content) {
        vmGamerlistInfo.ColumnWidthObj[col] = minWidth;
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmGamerlistInfo.datasource.forEach(function (el) {
            if (!app.LoginUser.IsAgent) {
                el.checked = checked;
            }
            else if (el.UserID != app.LoginUser.AgentID) {
                el.checked = checked;
            }
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmGamerlistInfo.allchecked = false
        } else {
            vmGamerlistInfo.allchecked = vmGamerlistInfo.datasource.every(function (el) {
                return el.checked
            })
        }
    }
})
var vmInfoReport = avalon.define({
    $id: 'vmInfoReport',
    moduleType: 1,
    reportView: 'basic',
    setReportView: function (view) {
        vmInfoReport.reportView = view;
        switch (view) {
            case 'basic':
                break;
            case 'richchange':
                vmInfoReport.findRichChange();
                break;
            case 'recharge':
                vmInfoReport.findRecharge();
                break;
            case 'loginlog':
                vmInfoReport.findLoginLog();
                break;
            case 'gift':
                vmInfoReport.findGift();
                break;
            case 'playgame':
                vmInfoReport.findPlayGame();
                break;
            case 'gamewaste':
                vmInfoReport.findGameWaste();
                break;
            case 'allsum':
                if (vmInfo.reportDialog.userType == 'gamer') {
                    vmInfoReport.findAllSum_Gamer();
                }
                else {
                    vmInfoReport.findAllSum();
                }
                break;
            case 'allplayer':
                vmInfoReport.findSpreadPlayer();
                break;
            default:
                break;
        }
    },
    datasource: [],
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    onRowChanged: function (e) {
    },
    Cond_Recharge: { Accounts: '', Range: -1, startDate: '', endDate: '' },
    Cond_Gift: { Accounts: '', OperationType: -1, startDate: '', endDate: '' },
    Cond_LoginLog: { startDate: '', endDate: '' },
    Cond_Rich: { rType: -1, startDate: '', endDate: '' },
    Cond_PlayGame: { GameID: -1, RoomID: -1, Accounts: '', startDate: '', endDate: '' },
    Cond_GameWaste: { GameID: -1, startDate: '', endDate: '' },
    Cond_AllSum: { startDate: '', endDate: '' },
    Cond_AllSum_Gamer: { startDate: '', endDate: '' },
    Cond_AllPlayer: { startDate: '', endDate: '' },
    Cond_AllPlayer_Gamer: { startDate: '', endDate: '' },
    ClearRechargeCond: function () {
        vmInfoReport.Cond_Recharge = { Accounts: '', Range: -1, startDate: '', endDate: '' };
    },
    ClearGiftCond: function () {
        vmInfoReport.Cond_Gift = { Accounts: '', OperationType: -1, startDate: '', endDate: '' };
    },
    ClearLoginLogCond: function () {
        vmInfoReport.Cond_LoginLog = { Accounts: '', OperationType: -1, startDate: '', endDate: '' };
    },
    ClearRichCond: function () {
        vmInfoReport.Cond_Rich = { rType: -1, startDate: '', endDate: '' };
    },
    ClearPlayGameCond: function () {
        vmInfoReport.Cond_PlayGame = { GameID: -1, RoomID: -1, Accounts: '', startDate: '', endDate: '' };
    },
    ClearGameWasteCond: function () {
        vmInfoReport.Cond_GameWaste = { GameID: -1, startDate: '', endDate: '' };
    },
    ClearAllSumCond: function () {
        vmInfoReport.Cond_AllSum = { startDate: '', endDate: '' };
    },
    ClearAllSum_GamerCond: function () {
        vmInfoReport.Cond_AllSum_Gamer = { startDate: '', endDate: '' };
    },
    ClearAllPlayerCond: function () {
        vmInfoReport.Cond_AllPlayer = { startDate: '', endDate: '' };
    },
    ClearAllPlayer_GamerCond: function () {
        vmInfoReport.Cond_AllPlayer_Gamer = { startDate: '', endDate: '' };
    },
    findRecharge: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getRecharge({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findGift: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getGift({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findLoginLog: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getLoginLog({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findRichChange: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getRichChange({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findPlayGame: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getPlayGame({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findGameWaste: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getGameWaste({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findAllSum: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getAllSum({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findAllSum_Gamer: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getAllSum_Gamer({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findSpreadPlayer: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getSpreadPlayer({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    getRecharge: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=recharge';
        querystring += '&Accounts=' + vmInfoReport.Cond_Recharge.Accounts;
        querystring += '&Range=' + vmInfoReport.Cond_Recharge.Range;
        querystring += '&startDate=' + vmInfoReport.Cond_Recharge.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_Recharge.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getGift: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=gift';
        querystring += '&Accounts=' + vmInfoReport.Cond_Gift.Accounts;
        querystring += '&OperationType=' + vmInfoReport.Cond_Gift.OperationType;
        querystring += '&startDate=' + vmInfoReport.Cond_Gift.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_Gift.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getLoginLog: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=loginlog';
        querystring += '&startDate=' + vmInfoReport.Cond_LoginLog.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_LoginLog.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getRichChange: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=richchange';
        querystring += '&rType=' + vmInfoReport.Cond_Rich.rType;
        querystring += '&startDate=' + vmInfoReport.Cond_Rich.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_Rich.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getPlayGame: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=playgame';
        querystring += '&GameID=' + vmInfoReport.Cond_PlayGame.GameID;
        querystring += '&RoomID=' + vmInfoReport.Cond_PlayGame.RoomID;
        querystring += '&Accounts=' + vmInfoReport.Cond_PlayGame.Accounts;
        querystring += '&startDate=' + vmInfoReport.Cond_PlayGame.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_PlayGame.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getGameWaste: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=gamewaste';
        querystring += '&GameID=' + vmInfoReport.Cond_GameWaste.GameID;
        querystring += '&startDate=' + vmInfoReport.Cond_GameWaste.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_GameWaste.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getAllSum: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=allsum';
        querystring += '&startDate=' + vmInfoReport.Cond_AllSum.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_AllSum.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getAllSum_Gamer: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring = '&subType=allsum_gamer';
        querystring += '&startDate=' + vmInfoReport.Cond_AllSum_Gamer.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_AllSum_Gamer.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getSpreadPlayer: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=spreadplayer';
        querystring += '&startDate=' + vmInfoReport.Cond_AllPlayer.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_AllPlayer.endDate;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    GameItems: [],
    RoomList: [],
    loadReportBind: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        var querystring = '&subType=reportbind';
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.GameItems = data.result.data.gamelist;
            vmInfoReport.RoomList = data.result.data.roomlist;
            vmInfoReport.getRoomList(-1);
        });
    },
    RoomListFilter: [],
    getRoomList: function (gameid) {
        var rlist = vmInfoReport.RoomList.$model;
        vmInfoReport.RoomListFilter.clear();
        if (gameid == -1) {
            for (var i in rlist) {
                vmInfoReport.RoomListFilter.push(rlist[i]);
            }
            return;
        }
        var roomArr = [];
        for (var i in rlist) {
            if (rlist[i].GameID === gameid) {
                vmInfoReport.RoomListFilter.push(rlist[i]);
            }
        }
    },
    selectGameChange: function (e) {
        var gameid = e.target.value;
        vmInfoReport.Cond_PlayGame.GameID = gameid;
        vmInfoReport.getRoomList(gameid);
    },
    relationText: '',
    relationDialogVisible: false,
    relationDialogStyle: { left: 0, top: 0, right: 0, bottom: 0, margin: 'auto' },
    showRelationDialog: function (e, r) {
        //vmInfoReport.relationDialogStyle = { left: e.clientX, top: e.clientY };
        vmInfoReport.relationText = r.Relation2;
        vmInfoReport.relationDialogVisible = true;
    },
    closeRelationDialog: function (e) {
        vmInfoReport.relationDialogVisible = false;
    },
    sortDesc: function (col) {
        if (vmInfoReport.selectedRowIndex !== -1) {
            vmInfoReport.datasource[vmInfoReport.selectedRowIndex].selected = false;
        }
        vmInfoReport.datasource.sort(function (a, b) {
            if (col == 'RechargeDate' || col == 'LoginTime' || col == 'LogoutTime' || col == 'GiftDate' || col == 'RecordTime' || col == 'StartDate') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmInfoReport.selectedRowIndex !== -1) {
            vmInfoReport.datasource[vmInfoReport.selectedRowIndex].selected = false;
        }
        vmInfoReport.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'RechargeDate' || col == 'LoginTime' || col == 'LogoutTime' || col == 'GiftDate' || col == 'RecordTime' || col == 'StartDate') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    }
});
var vmInfoSpreadSum = avalon.define({
    $id: 'vmInfoSpreadSum',
    moduleType: 1,
    AData: [],
    BData: [],
    CData: [],
    UserID: -1,
    selectedDate: '',
    loadData: function (UserID) {
        vmInfoSpreadSum.UserID = UserID;
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=spreadsum&UserID=' + UserID + '&today=' + vmInfoSpreadSum.selectedDate;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoSpreadSum.AData = data.result.A;
            vmInfoSpreadSum.BData = data.result.B;
            vmInfoSpreadSum.CData = data.result.C;
            vmInfoSpreadSum.RealSpreadSum = data.result.RealSpreadSum;

            vmInfoSpreadSum.SumData(['A', 'B', 'C'], 'TodayWaste', 'WasteSum');
            vmInfoSpreadSum.SumData(['A', 'B', 'C'], 'TodayCommission', 'SpreadSum');
        });
    },
    loadDataByDate: function (e) {
        vmInfoSpreadSum.loadData(vmInfoSpreadSum.UserID);
    },
    SumData: function (types, prop, sumprop) {
        for (var t in types) {
            var type = types[t];
            var sum = 0;
            var data = vmInfoSpreadSum[type + 'Data'].$model;
            for (var i in data) {
                sum += (+data[i][prop]);
            }
            vmInfoSpreadSum[type + sumprop] = sum;
        }
    },
    RealSpreadSum: 0,
    AWasteSum: 0,
    BWasteSum: 0,
    CWasteSum: 0,
    ASpreadSum: 0,
    BSpreadSum: 0,
    CSpreadSum: 0
});

var vmSubAgentlistInfo = avalon.define({
    $id: 'vmSubAgentlistInfo',
    moduleType: 1,
    condition: { SpreaderID: '', Accounts: '', Range: 0, startDate: '', endDate: '', userType: 'admin', byUserID: -1 },
    datasource: [],
    selectedRow: {},
    selectedRowIndex: -1,
    IsFind: 0,
    onRowChanged: function (i, r) {
        if (i === vmSubAgentlistInfo.selectedRowIndex) return;

        if (vmSubAgentlistInfo.selectedRowIndex !== -1) {
            vmSubAgentlistInfo.datasource[vmSubAgentlistInfo.selectedRowIndex].selected = false;
        }
        vmSubAgentlistInfo.datasource[i].selected = true;

        vmSubAgentlistInfo.selectedRowIndex = i;
        vmSubAgentlistInfo.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    fillGrid: function (e) {
        if (vmInfo.selectedTreeNode.IsAgent) {
            vmSubAgentlistInfo.condition.userType = 'agent';
        }
        else {
            vmSubAgentlistInfo.condition.userType = 'admin';
        }

        var querystring = '&moduleType=' + vmlog.moduleType;
        querystring += '&subType=subagentlist';
        querystring += '&SpreaderID=' + (vmSubAgentlistInfo.condition.SpreaderID || '-1');
        querystring += '&Accounts=' + vmSubAgentlistInfo.condition.Accounts;
        querystring += '&Range=' + vmSubAgentlistInfo.condition.Range;
        querystring += '&startDate=' + vmSubAgentlistInfo.condition.startDate;
        querystring += '&endDate=' + vmSubAgentlistInfo.condition.endDate;
        querystring += '&userType=' + vmSubAgentlistInfo.condition.userType;
        querystring += '&byUserID=' + vmSubAgentlistInfo.condition.byUserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmSubAgentlistInfo.datasource.clear();
            vmSubAgentlistInfo.datasource = data.result.data;
            vmSubAgentlistInfo.config.totalPage = data.result.totalPage;
            vmSubAgentlistInfo.config.totalCount = data.result.totalCount;
        });
    },
    findNew: function () {
        if (vmSubAgentlistInfo.IsFind == 0) {
            vmSubAgentlistInfo.IsFind = 1;
            vmSubAgentlistInfo.config.pageIndex = 1;
            vmSubAgentlistInfo.fillGrid({ pageIndex: 1, pageSize: vmSubAgentlistInfo.config.pageSize });
        }
    },
    find: function () { 
            vmSubAgentlistInfo.config.pageIndex = 1;
            vmSubAgentlistInfo.fillGrid({ pageIndex: 1, pageSize: vmSubAgentlistInfo.config.pageSize });
    },
    clearDatasource: function () {
        vmSubAgentlistInfo.datasource.clear();
        vmSubAgentlistInfo.config.totalPage = 0;
        vmSubAgentlistInfo.config.totalCount = 0;
    },
    clearCondition: function () {
        vmSubAgentlistInfo.condition.SpreaderID = '';
        vmSubAgentlistInfo.condition.Accounts = '';
        vmSubAgentlistInfo.condition.Range = 0;
        vmSubAgentlistInfo.condition.startDate = '';
        vmSubAgentlistInfo.condition.endDate = '';
    },
    getIds: function (idname) {
        var ids = '';
        var dm = vmSubAgentlistInfo.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i][idname];
            }
        }
        return ids.substring(1, ids.length);;
    },
    checkIds: function () {
        var ids = vmSubAgentlistInfo.getIds('UserID');
        return ids;
    },

    sortDesc: function (col) {
        if (vmSubAgentlistInfo.selectedRowIndex !== -1) {
            vmSubAgentlistInfo.datasource[vmSubAgentlistInfo.selectedRowIndex].selected = false;
        }
        vmSubAgentlistInfo.datasource.sort(function (a, b) {
            if (col == 'SpreaderDate') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmSubAgentlistInfo.selectedRowIndex !== -1) {
            vmSubAgentlistInfo.datasource[vmSubAgentlistInfo.selectedRowIndex].selected = false;
        }
        vmSubAgentlistInfo.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'SpreaderDate') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmSubAgentlistInfo.datasource.forEach(function (el) {
            el.checked = checked
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmSubAgentlistInfo.allchecked = false
        } else {
            vmSubAgentlistInfo.allchecked = vmSubAgentlistInfo.datasource.every(function (el) {
                return el.checked
            })
        }
    }
});
var vmInfo = avalon.define({
    $id: 'vminfo',
    moduleType: 1,
    vmState: 'none',
    tabs: [
        { title: '基本信息', tabpage: 'basic', active: true },
        { title: '玩家列表', tabpage: 'gamerlist', active: false },
        { title: '子代理商', tabpage: 'myagent', active: false }
    ],
    selectedTabIndex: 0,
    selectedTabPage: 'basic',
    onSelectTab: function (i, p) {
        if (vmInfo.selectedTabIndex === i) return;

        vmInfo.tabs[vmInfo.selectedTabIndex].active = false;
        vmInfo.tabs[i].active = true;
        vmInfo.selectedTabIndex = i;
        vmInfo.selectedTabPage = p;
        if (vmInfo.selectedTabPage === 'gamerlist') {
            vmGamerlistInfo.findNew();
        }
        else if (vmInfo.selectedTabPage === 'myagent') {
            vmSubAgentlistInfo.findNew();
        }
    },
    AgentLevelLimits: [{ LevelLimit: 1, LevelLimitDes: '1级' }, { LevelLimit: 2, LevelLimitDes: '2级' }],
    AgentLevelLimitsDisabled: true,
    createAgentLevelLimits: function (limit) {
        vmInfo.AgentLevelLimits.clear();
        for (var i = 1; i < limit; i++) {
            vmInfo.AgentLevelLimits.push({ LevelLimit: i, LevelLimitDes: i + '级' });
        }
    },
    setAgentLevelLimitsDisabled: function (limit) {
        vmInfo.AgentLevelLimitsDisabled = (limit <= 2 ? true : false);
    },
    newUser: { UserID: -1, UserName: '', Nick: '', Sex: 1, Password: '123456', cfPassword: '123456', canHasSub: 0, AgentLevelLimit: 1, Revenue: '', RoleID: -1, GradeID: -1 },
    editUser: { UserID: -1, UserName: '', Nick: '', Sex: 1, canHasSub: 0, AgentLevelLimit: '', Revenue: '', AgentStatus: 0, RoleID: -1, GradeID: -1 },
    clearNewUser: function () {
        vmInfo.newUser = { UserID: -1, UserName: '', Nick: '', Sex: 1, Password: '', cfPassword: '', canHasSub: 0, AgentLevelLimit: '', Revenue: '', RoleID: -1 };
    },
    loadTree: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=tree&UserID=' + app.LoginUser.UserID;
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            MessageBox.success(data);
            vmInfo.tree = data.result.tree;
        });
    },
    AdminStatInfo: { Allcount: 0, AgentCount: '', PlatformCount: 0, TopAgentCount: 0, SubAgentCount: 0, OnLineCount: 0, AgentOnLineCount: 0, PlatformOnLineCount: 0, Recharge: 0, AgentRecharge: 0, PlatformRecharge: 0, Waste: 0, AgentWaste: 0, PlatformWaste: 0, Score: 0, AgentScore: 0, PlatformScore: 0 },
    findAdminStatInfo: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            if (data.result.data) {
                vmInfo.AdminStatInfo = data.result.data.info[0];
            }
        });
        return false;
    },
    AgentStatInfo: { GameID: 0, Accounts: '', NickName: '', DirectGamerWaste: 0, DirectGamerScore: 0, OnLineCount: 0, OnLineCount: 0, DirectGamerCount: 0, DirectAgentCount: 0, AgentStatus: 0, AllGamerWaste: 0, AllGamerScore: 0, Recharge: 0, AllGamerCount: 0, AllAgentCount: 0, AgentLevelLimit: '', ProfitRate: 0, canHasSubAgent: 0, SpreaderDate: '' },
    findAgentStatInfo: function (UserID) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        if (UserID) {
            querystring += '&UserID=' + UserID;
        }
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            MessageBox.success(data);
            if (data.result.data) {
                vmInfo.AgentStatInfo = data.result.data.info[0];
            }
        });
        return false;
    },
    roleChange: function (e) {
        var roleid = e.target.value;
        vmInfo.newUser.RoleID = roleid;
        vmInfo.editUser.RoleID = roleid;
        var roles = vmInfo.roles.$model.slice();
        var r = roles.filter(function (el) {
            return el.RoleID === roleid;
        });
        var level = r[0].AgentLevel;
        var model = 'newUser';
        if (vmInfo.vmState === 'edit') {
            model = 'editUser';
        }

        if (level <= 1) {
            vmInfo[model].canHasSub = 1;
            vmInfo[model].AgentLevelLimit = 2;
            vmInfo.AgentLevelLimitsDisabled = false;
        }
        else {
            vmInfo[model].canHasSub = 0;
            vmInfo[model].AgentLevelLimit = 1;
            vmInfo.AgentLevelLimitsDisabled = true;
        }

    },
    addUser: function (e, controller, querystring, cbFunc) {
        var data = $(e.target).serialize();
        if (vmInfo.newUser.UserName == '') {
            alert('账号不能为空！');
            return;
        }
        Du.PostFormData(controller, 'New', querystring, data, function (data) {
            if (cbFunc) { cbFunc(); }
            vmInfo.resetData(data);
        });
    },
    addGamerSubmit: function (e) {
        vmInfo.newUser.Password = '';
        vmInfo.newUser.cfPassword = '';
        vmInfo.addUser(e, 'Gamer', '', vmInfo.closeGamerDialog);
    },
    addAgentSubmit: function (e) {
        if (vmInfo.newUser.Revenue === '') {
            alert('盈利税收不能为空！');
            return;
        }
        var querystring = '&IsAgent=' + vmInfo.selectedTreeNode.IsAgent;
        vmInfo.addUser(e, 'SubAgents', querystring, vmInfo.closeAgentDialog);
    },
    editAgentSubmit: function (e) {
        var data = $(e.target).serialize();
        var querystring = "&AdminID=" + vmInfo.selectedTreeNode.AdminID;
        Du.PostFormData('SubAgents', 'Edit', querystring, data, function (data) {
            vmInfo.resetData(data);
            vmInfo.closeSettingDialog();
        });
    },
    resetData: function (data) {
        if (data.status === "success") {
            vmInfo.loadTree();
            vmInfo.findAdminStatInfo();
            vmInfo.findAgentStatInfo(vmInfo.selectedTreeNode.id);
            vmInfo.showAgentSmartMenuLi = false;
            vmInfo.showGamerSmartMenuLi = false;
            vmInfo.showSettingSmartMenuLi = false;
            vmInfo.clearNewUser();
        }
        MessageBox.show(data);
    },
    //SpreaderIdChoiceVisible: false,
    SpreaderIDList: [],
    getTopSpreader: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=spreaderidlist';
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            MessageBox.success(data);
            vmInfo.SpreaderIDList = data.message;
        });
    },
    CodeID: -1,
    //chooseSpreaderID: function (codeId, e) {
    //    vmInfo.CodeID = codeId;
    //    $('.choice.choice-spreaderid span').removeClass('selected');
    //    $(e.currentTarget).addClass('selected');
    //},
    openSpreaderIdChoice: function (e, i) {
        vmInfo.getTopSpreader();
        //vmInfo.SpreaderIdChoiceVisible = true;
        $('#txtSpreaderID' + (i == 2 ? '2' : '')).addClass('visible');
        $('#txtSpreaderID' + (i == 2 ? '2' : '')).focus();
        $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).removeClass('visible');
        var code = $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).text();
        $('#txtSpreaderID' + (i == 2 ? '2' : '')).val(code);
        vmInfo.CodeID = code;
        //$('.choice.choice-spreaderid').css({ zIndex: 2000 });
        //$('.choice.choice-spreaderid span').removeClass('selected');
        vmInfo.saveBtnVisible = true;
        vmInfo.openBtnVisible = false;
    },
    closeSpreaderIdChoice: function (i) {
        //vmInfo.SpreaderIdChoiceVisible = false;
        $('#txtSpreaderID' + (i == 2 ? '2' : '')).removeClass('visible');
        $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).addClass('visible');
        vmInfo.saveBtnVisible = false;
        vmInfo.openBtnVisible = true;
    },
    changeSpreaderID: function (e) {
        vmInfo.CodeID = $(e.currentTarget).val();
    },
    openBtnVisible: true,
    saveBtnVisible: false,
    saveSpreaderID: function (e, i) {
        var code = vmInfo.CodeID.trim();
        if (!/^[A-Za-z0-9]{3,6}$/.test(code)) {
            alert('格式不正确,邀请码只能由3-6个字母数字组成！');
            vmInfo.closeSpreaderIdChoice();
            return false;
        }
        var oldCode = $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).text();
        if (oldCode === code) {
            vmInfo.closeSpreaderIdChoice();
            return false;
        }
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=spreaderid&UserID=' + vmInfo.selectedTreeNode.id + '&UserName='
            + vmInfo.selectedTreeNode.UserName + '&SpreaderID=' + code + '&oldSpreaderID=' + oldCode,
        Du.PostEx('SubAgents', 'Edit', querystring, function (data) {
            $('#txtSpreaderID' + (i == 2 ? '2' : '')).removeClass('visible');
            $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).addClass('visible');
            vmInfo.openBtnVisible = true;
            vmInfo.saveBtnVisible = false;
            if (data.status == 'success') {
                vmInfo.AgentStatInfo.SpreaderID = code;
            }
            $('#txtSpreaderID' + (i == 2 ? '2' : '')).val('');
        }, function (err) {
            $('#txtSpreaderID' + (i == 2 ? '2' : '')).removeClass('visible');
            $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).addClass('visible');
            MessageBox.error(err.responseText);
        }
    );
        return false;
    },
    copySpreaderURL: function (event, id) {
        var succ = copyToClipboard(document.getElementById(id));
        if (succ) {
            alert('成功复制到剪切板！');
        }
    },
    agentAnimation: 'enter',
    gamerAnimation: 'enter',
    settingAnimation: 'enter',
    openAgentDialog: function (e) {
        vmInfo.newUser.Password = '123456';
        vmInfo.newUser.cfPassword = '123456';
        vmInfo.agentAnimation = 'leave';
    },
    openGamerDialog: function (e) {
        vmInfo.gamerAnimation = 'leave';
    },
    openSettingDialog: function (e) {
        vmInfo.settingAnimation = 'leave';
    },
    closeAgentDialog: function (e) {
        vmInfo.agentAnimation = 'enter';
        vmInfo.resetSmartMenu();
    },
    closeGamerDialog: function (e) {
        vmInfo.gamerAnimation = 'enter';
        vmInfo.resetSmartMenu();
    },
    closeSettingDialog: function (e) {
        vmInfo.settingAnimation = 'enter';
        vmInfo.resetSmartMenu();
    },
    showAgentSmartMenuLi: false,
    showGamerSmartMenuLi: false,
    showSettingSmartMenuLi: false,
    showCanHasSubAgent: false,
    resetSmartMenu: function () {
        vmInfo.vmState = "none";
        vmInfo.showAgentSmartMenuLi = false;
        vmInfo.showGamerSmartMenuLi = false;
        vmInfo.showSettingSmartMenuLi = false;
    },
    selectedTreeNode: { id: -1, parentId: -1, AdminID: -1, UserName: '', IsAgent: false, ParentsAgentLevelCount: 0, AgentLevelLimit: 0 },
    tree: [],
    renderSubTree: function (el) {
        if (!el.subtree) return '';
        return el.subtree.length ? '<ul><li ms-for="(index, el) in el.subtree" ms-class="[\'item\',\'item-\'+el.ag,\'item-l-\'+el.level,\'item-\'+el.type]"><div class="title"><span ms-class="el.subtree.length?(\'iconfont \'+(el.open?\'icon-rightdown\':\'icon-right\')):\'none\'" ms-click="@openSubTree(el) | stop"></span><span class="iconfont icon-ren"></span><span class="title-text" ms-click="@onTreeNodeSelected(el,$event)" ms-on-contextmenu="@onContextMenu(el,$event)">{{el.title}}<span class="rolename" ms-on-contextmenu="@onContextMenu(el,$event)">{{el.GradeDes}}</span></span></div><div ms-visible="el.open" ms-html="@renderSubTree(el)" class="subtree"></div></li></ul>' : '';
    },
    openSubTree: function (el) {
        el.open = !el.open;
    },
    //////////////////////////////////////////////////////////////////////////////////////////////
    onTreeNodeSelected: function (el, e) {
        $('.tree .item .title').css({ background: 'transparent' });
        $(e.target).parents('.title').css({ background: '#8ce' });
        vmInfo.newUser.RoleID = el.RoleID;
        vmGamerlistInfo.condition.byUserID = el.id;
        vmSubAgentlistInfo.condition.byUserID = el.id;

        if (vmInfo.selectedTreeNode.id != el.id) {
            vmInfo.selectedTreeNode.id = el.id;
            vmInfo.selectedTreeNode.RoleID = el.RoleID;
            vmInfo.selectedTreeNode.UserName = el.title;
            vmInfo.selectedTreeNode.AdminID = el.AdminID;
            vmInfo.selectedTreeNode.parentId = el.parentId;
            vmInfo.selectedTreeNode.IsAgent = el.type == 'agent' ? true : false;
            vmInfo.closeSpreaderIdChoice(1);
            vmInfo.closeSpreaderIdChoice(2);
            if (el.type == 'admin') {
                vmInfo.findAdminStatInfo();
                //vmGamerlistInfo.find();
                //vmSubAgentlistInfo.find();
            } else {
                vmInfo.findAgentStatInfo(el.id);
                //vmGamerlistInfo.find();
                //vmSubAgentlistInfo.find();
            }
            if (vmInfo.selectedTabPage === 'gamerlist') {
                vmGamerlistInfo.find();
            } else {
                vmGamerlistInfo.IsFind = 0;
            }
            if (vmInfo.selectedTabPage === 'myagent') {
                vmSubAgentlistInfo.find();
            } else {
                vmSubAgentlistInfo.IsFind = 0;
            }

        }
        vmInfo.reportDialog.UserID = el.id;
        vmInfo.reportDialog.userType = el.type;
        vmInfo.reportDialog.title = '代理商基本数据 - ' + el.title;
    },
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    onContextMenu: function (el, e) {
        $('.tree .item .title').css({ background: 'transparent' });
        $(e.target).parents('.title').css({ background: '#8ce' });
        $('.lev-contextmenu').addClass("visible");
        $('.lev-contextmenu').css({ left: e.clientX, top: e.clientY });
        $('.lev-contextmenu .item *').css({ color: "#ccc" });
        $('.lev-contextmenu .item.item-refresh *').css({ color: "#111" });

        if (app.LoginUser.IsAgent) {
            if (el.AdminID == app.LoginUser.UserID) {
                if (el.canHasSubAgent) {
                    $('.lev-contextmenu .item-agent *').css({ color: "#111" });
                    vmInfo.showAgentSmartMenuLi = true;
                    //vmInfo.createAgentLevelLimits(el.AgentLevelLimit);
                    //vmInfo.setAgentLevelLimitsDisabled(el.AgentLevelLimit);
                }
                $('.lev-contextmenu .item-gamer *').css({ color: "#111" });
                vmInfo.showGamerSmartMenuLi = true;
                vmInfo.showSettingSmartMenuLi = false;
            }
            else if (app.LoginUser.AgentID = el.parentId) {
                $('.lev-contextmenu .item-setting *').css({ color: "#111" });
                vmInfo.showAgentSmartMenuLi = false;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = true;
            }
            else {
                $('.lev-contextmenu .item *').css({ color: "#ccc" });
                vmInfo.showAgentSmartMenuLi = false;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = false;
            }
        }
        else {
            if (el.AdminID == app.LoginUser.UserID) {
                $('.lev-contextmenu .item-agent *').css({ color: "#111" });
                vmInfo.showAgentSmartMenuLi = true;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = false;
                vmInfo.AgentLevelLimitsDisabled = false;
            }
            else if (el.parentId == 0) {
                $('.lev-contextmenu .item-setting *').css({ color: "#111" });
                vmInfo.showAgentSmartMenuLi = false;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = true;
            }
            else {
                $('.lev-contextmenu .item *').css({ color: "#ccc" });
                vmInfo.showAgentSmartMenuLi = false;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = false;
            }
        }

        vmInfo.newUser.UserID = el.id;
        vmInfo.newUser.RoleID = el.RoleID;
        vmInfo.selectedTreeNode.id = el.id;
        vmInfo.selectedTreeNode.RoleID = el.RoleID;
        vmInfo.selectedTreeNode.UserName = el.title;
        vmInfo.selectedTreeNode.AdminID = el.AdminID;
        vmInfo.selectedTreeNode.parentId = el.parentId;
        vmInfo.selectedTreeNode.IsAgent = el.type == 'agent' ? true : false;
        return false;
    },
    reportDialog: { UserID: -1, userType: 'admin', title: '基本数据' },
    spreadsumDialog: { title: '基本数据' },
    gamerDetail: { GameID: '', Accounts: '', NickName: '', InviteCode: '', LoginStatus: '', Experience: 0, Level: 0, Score: 0, InsureScore: 0, Diamond: 0, RCard: 0, GamerSpreaderSum: 0, LoginTimes: 0, RegisterIP: '', SpreaderDate: '', LastLogonIP: '', LastLogonDate: '' },
    openReport: function (row, userType) {
        //vmInfo.reportVisible = true;
        vmInfo.reportAnimation = 'leave';

        if (row) {
            vmInfo.reportDialog.UserID = row.UserID;
            vmInfo.reportDialog.userType = userType;
            vmInfo.reportDialog.title = '玩家基本数据 - ' + '' + row['GameID'] + '(' + row['NickName'] + ')';
            var gd = vmInfo.gamerDetail.$model;
            for (var i in gd) {
                $('#gamerDetail-' + i.toString()).text(row[i]);
            }
        }
    },
    closeReport: function () {
        //vmInfo.reportVisible = false;
        vmInfo.reportAnimation = 'enter';

        vmInfoReport.setReportView('basic');
        vmInfo.reportDialog.UserID = vmInfo.selectedTreeNode.id;
        vmInfo.reportDialog.userType = vmInfo.selectedTreeNode.IsAgent ? 'agent' : 'admin';
        vmInfo.reportDialog.title = '基本数据';
        vmInfoReport.closeRelationDialog();
    },
    reportVisible: false,
    reportAnimation: 'enter',
    setReportVisible: function () {
        //vmInfo.reportVisible = !vmInfo.reportVisible;
        vmInfo.reportAnimation = 'leave';
    },
    checkIds: function () {
        var ids;
        if (vmInfo.selectedTabPage == 'gamerlist') {
            ids = vmGamerlistInfo.checkIds();
        }
        else if (vmInfo.selectedTabPage == 'myagent') {
            ids = vmSubAgentlistInfo.checkIds();
        }
        return ids;
    },
    AddGiftGold: function (e) {
        if (vmInfo.GiftGoldForm.GiftGold.trim() === "") {
            alert('请输入金币数量！');
            return false;
        }
        if (vmInfo.GiftGoldForm.Reason.trim() === "") {
            alert('请输入赠送原因！');
            return false;
        }
        var ids = vmInfo.checkIds();
        var querystring = '&moduleType=' + vmadmin.moduleType + '&IsAgent=' + app.LoginUser.IsAgent;
        var data = '&ids=' + ids + '&GiftGold=' + vmInfo.GiftGoldForm.GiftGold + '&Reason=' + vmInfo.GiftGoldForm.Reason;
        Du.PostFormData('RecordGrantTreasure', 'New', querystring, data, function (data) {
            vmInfo.refreshDatasource();
            vmInfo.closeGiveGoldDialog();
            MessageBox.show(data);
        });
        return false;
    },
    AddRCard: function (e) {
        if (vmInfo.GiftRCardForm.RCard.trim() === "") {
            alert('请输入房卡数量！');
            return false;
        }
        if (vmInfo.GiftRCardForm.Reason.trim() === "") {
            alert('请输入赠送原因！');
            return false;
        }
        var ids = vmInfo.checkIds();
        var querystring = '&moduleType=' + vmadmin.moduleType + '&IsAgent=' + app.LoginUser.IsAgent;
        var data = '&ids=' + ids + '&RCard=' + vmInfo.GiftRCardForm.RCard + '&Reason=' + vmInfo.GiftGoldForm.Reason;
        Du.PostFormData('RecordGrantRCard', 'New', querystring, data, function (data) {
            vmInfo.refreshDatasource();
            vmInfo.closeGiveRCardDialog();
            MessageBox.show(data);
        });
        return false;
    },
    refreshDatasource: function () {
        if (vmInfo.selectedTabPage === 'gamerlist') {
            vmGamerlistInfo.find();
        }
        else {
            vmSubAgentlistInfo.find();
        }
    },
    GiveGoldDialogVisible: false,
    GiveRCardDialogVisible: false,
    GiveGoldDialogAnimation: 'enter',
    GiveRCardDialogAnimation: 'enter',
    showGiveGoldDialog: function () {
        if (!vmInfo.checkIds()) {
            alert('请勾选行！');
            return;
        }
        //vmInfo.GiveGoldDialogVisible = !vmInfo.GiveGoldDialogVisible;
        vmInfo.GiveGoldDialogAnimation = "leave";
    },
    closeGiveGoldDialog: function () {
        vmInfo.GiveGoldDialogAnimation = "enter";
        vmInfo.GiftGoldForm = { GiftGold: 0, Reason: '' };
    },
    showGiveRCardDialog: function () {
        if (!vmInfo.checkIds()) {
            alert('请勾选行！');
            return;
        }
        //vmInfo.GiveRCardDialogVisible = !vmInfo.GiveRCardDialogVisible;
        vmInfo.GiveRCardDialogAnimation = "leave";
    },
    closeGiveRCardDialog: function () {
        vmInfo.GiveRCardDialogAnimation = "enter";
        vmInfo.GiftRCardForm = { RCard: 0, Reason: '' };
    },
    roles: [],
    grades: [],
    GradeIDFilter: function (el) {
        if (vmInfo.vmState == 'add')
            return vmInfo.newUser.RoleID === el.RoleID;
        else
            return vmInfo.editUser.RoleID === el.RoleID;
    },
    getAddAgentBindData: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=add_binddata&AgentLevel=' + app.LoginUser.AgentLevel;
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            vmInfo.roles = data.result.AgentRoles;
            var roleid = data.result.AgentRoles[0].RoleID;
            vmInfo.roleChange({ target: { value: roleid } });
            if (vmInfo.vmState == 'add') {
                vmInfo.newUser.RoleID = roleid
            }
            else {
                vmInfo.editUser.RoleID = roleid;
            }
            vmInfo.grades = data.result.AgentGrades;
        });
    },
    init: function () {
        vmInfo.loadTree();
        //vmGamerlistInfo.find();
        //vmSubAgentlistInfo.find();
        vmInfoReport.loadReportBind();

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //右键菜单
        $('.lev-contextmenu .item').hover(function () {
            $(this).find('.sub').addClass('visible');
        });
        $('.lev-contextmenu .item').mouseleave(function () {
            $(this).find('.sub').removeClass('visible');
        });
        $('.lev-contextmenu .sub .item .title').click(function () {
            $('.lev-contextmenu').removeClass("visible");
        });
        $('body').click(function () {
            $('.lev-contextmenu').removeClass("visible");
        });
        $('.lev-contextmenu .item-agent .action').click(function () {
            //代理 - 新增
            if (!vmInfo.showAgentSmartMenuLi) {
                $('.lev-contextmenu').removeClass("visible");
                return false;
            }
            vmInfo.getAddAgentBindData();
            vmInfo.openAgentDialog();
            vmInfo.vmState = "add";
            $('.lev-contextmenu').removeClass("visible");
            return false;
        });
        $('.lev-contextmenu .item-gamer .action').click(function () {
            //玩家 - 新增
            if (!vmInfo.showGamerSmartMenuLi) {
                $('.lev-contextmenu').removeClass("visible");
                return false;
            }
            vmInfo.openGamerDialog();
            vmInfo.vmState = "add";
            $('.lev-contextmenu').removeClass("visible");
            return false;
        });
        $('.lev-contextmenu .item-setting .action').click(function () {
            //设置 - 属性
            if (!vmInfo.showSettingSmartMenuLi) {
                $('.lev-contextmenu').removeClass("visible");
                return false;
            }
            vmInfo.getAddAgentBindData();
            vmInfo.openSettingDialog();
            vmInfo.vmState = "edit";
            $('.lev-contextmenu').removeClass("visible");

            var url = '/ajaxControllers.ashx?controller=SubAgents&type=Index&subType=byId&UserID=' + vmInfo.selectedTreeNode.id;

            $.ajax({
                url: url,
                method: 'GET',
                success: function (data) {
                    MessageBox.success(data);
                    var eu = data.result[0];
                    if (eu) {
                        if (vmInfo.selectedTreeNode.IsAgent)
                            eu.canHasSub = (eu.canHasSub == 'False' ? 0 : 1);
                        vmInfo.editUser = eu;
                    }
                },
                error: function (err) {
                    MessageBox.error(err.responseText);
                }
            })
            return false;
        });
        $('.lev-contextmenu .item-refresh').click(function () {
            vmInfo.loadTree();
        });
    },
    spreadSumDialogVisible: false,
    spreadsumAnimation: 'enter',
    openSpreadSumDialog: function (r) {
        //vmInfo.spreadSumDialogVisible = true;
        vmInfo.spreadsumAnimation = 'leave';
        vmInfo.spreadsumDialog.title = '玩家今日返利明细 - ' + r.GameID + '(' + r.NickName + ')';
        vmInfoSpreadSum.selectedDate = new Date().Format('yyyy-MM-dd');
        vmInfoSpreadSum.loadData(r.UserID);
    },
    closeSpreadSumDialog: function () {
        vmInfo.spreadsumAnimation = 'enter';
    },
    gridsorticon: false,
    toggleGridSortBtn: function () {
        vmInfo.gridsorticon = !vmInfo.gridsorticon;
    },
    GiftGoldForm: { GiftGold: 0, Reason: '' },
    GiftRCardForm: { RCard: 0, Reason: '' },
    checkSensitive: function (e) {
        var word = e.target.value.trim();
    }
});
vmInfo.$watch('onReady', function () {
    setTimeout(function () {
        $('input[data-date="datepicker"]').datepicker({
            format: 'yyyy-mm-dd'
        });
    });
    vmInfo.onTreeNodeSelected(vmInfo.tree[0], { target: '.tree li.item-admin>.title .title-text' });
});
vmInfo.$watch('tree', function () {
    if (!app.LoginUser.IsAgent) {
        //vmInfo.onTreeNodeSelected(vmInfo.tree[0], { target: '.tree li.item-admin .title .title-text' });
    }
});
var vmlog = avalon.define({
    $id: 'vmlog',
    moduleType: 6,
    datasource: [],
    columns: [],
    condition: { startDate: '', endDate: '', OperationID: -1, Accounts: '' },
    operations: [],
    selectedRowIndex: 0,
    selectedRow: {},
    IsFind: 0,
    /***********注入grid的方法**************/
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmlog.moduleType;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;
        querystring += '&startDate=' + vmlog.condition.startDate + '&endDate=' + vmlog.condition.endDate;
        querystring += '&OperationID=' + vmlog.condition.OperationID;
        querystring += '&userType=' + (app.LoginUser.IsAgent ? 'agent' : 'admin');
        querystring += '&byAdminID=' + app.LoginUser.UserID;

        Du.Loading('Log', 'Index', querystring, function (data) {
            vmlog.datasource = data.result.data;
            vmlog.config.totalPage = data.result.totalPage;
            vmlog.config.totalCount = data.result.totalCount;
        });
    },
    find: function () {
        vmlog.config.pageIndex = 1;
        vmlog.fillGrid({ pageIndex: 1, pageSize: vmlog.config.pageSize });
    },
    findNew: function () {
        if (vmlog.IsFind == 0) {
            vmlog.IsFind = 1;
            vmlog.config.pageIndex = 1;
            vmlog.fillGrid({ pageIndex: 1, pageSize: vmlog.config.pageSize });
        }
    },
    reset: function () {
        vmlog.condition = { startDate: '', endDate: '', OperationID: -1, Accounts: '' };
    },
    onGridSelectedRowChanged: function (i, r) {
        if (i === vmlog.selectedRowIndex) return;

        if (vmlog.selectedRowIndex !== -1) {
            vmlog.datasource[vmlog.selectedRowIndex].selected = false;
        }
        vmlog.datasource[i].selected = true;
        vmlog.selectedRowIndex = i;
        vmlog.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    /*************************************/
    getOperations: function () {
        var querystring = '&moduleType=' + vmlog.moduleType + '&dataType=operations';
        Du.Get('Log', 'Index', querystring, function (data) {
            vmlog.operations = data.result;
        });
    },
    init: function () {
        vmlog.getOperations();
        vmlog.find();
    },
    sortDesc: function (col) {
        if (vmlog.selectedRowIndex !== -1) {
            vmlog.datasource[vmlog.selectedRowIndex].selected = false;
        }
        vmlog.datasource.sort(function (a, b) {
            if (col == 'PreLogintime' || col == 'LastLogintime') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });
    },
    sortAsc: function (col) {
        if (vmlog.selectedRowIndex !== -1) {
            vmlog.datasource[vmlog.selectedRowIndex].selected = false;
        }
        vmlog.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'LastLogintime' || col == 'PreLogintime') {
                return new Date(a[col]) > new Date(b[col]);
            }

            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmlog.datasource.forEach(function (el) {
            el.checked = checked
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmlog.allchecked = false
        } else {
            vmlog.allchecked = vmlog.datasource.every(function (el) {
                return el.checked
            })
        }
    }
});
vmlog.$watch('onReady', function () {
    setTimeout(function () {
        $('input[data-date="datepicker"]').datepicker({
            format: 'yyyy-mm-dd'
        });
    });
});
var vmMenu = avalon.define({
    $id: 'menu',
    datasource: [],
    menuArr: [],
    submenuArr: [],
    selectedItem: '',
    selectedItemIndex: 0,
    init: function (e) {
        vmMenu.loadViews(app.LoginUser.IsAgent);
        vmMenu.getMenus();
    },
    viewdata: {
        admin: [{ id: 1, title: '代理管理', sid: '', href: '#', view: '', vm: '', hasdetail: false, ico: 'icon-daili', parentId: 0, active: false, open: true, animation: 'enter' },
            { id: 101, title: '代理信息', sid: 'info', href: '#!/info', view: 'info.html', vm: 'vminfo', hasdetail: false, ico: 'levan.ico', parentId: 1, active: false, module: 1 },
            { id: 102, title: '代理商帐号', sid: 'subagentlist', href: '#!/subagentlist', view: 'subagentlist.html', vm: 'vmsubagentlist', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 2 },
            { id: 103, title: '管理员帐号', sid: 'admin', href: '#!/admin', view: 'admin.html', vm: 'vmadmin', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 3 },
            { id: 104, title: '角色管理', sid: 'roles', href: '#!/roles', view: 'roles.html', vm: 'vmroles', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 4 },
            { id: 105, title: '返利配置', sid: 'spreaderoptions', href: '#!/spreaderoptions', view: 'spreaderoptions.html', vm: 'vmspreaderoptions', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 5 },
            { id: 2, title: '系统管理', sid: '', href: '#', view: '', vm: '', hasdetail: false, ico: 'icon-setting', parentId: 0, active: false, open: true, animation: 'enter' },
            { id: 201, title: '操作日志', sid: 'log', href: '#!/log', view: 'log.html', vm: 'vmlog', hasdetail: false, ico: 'levan.ico', parentId: 2, active: false, module: 6 },
            { id: 202, title: '敏感词过滤', sid: 'sensitiveword', href: '#!/sensitiveword', view: 'sensitiveword.html', vm: 'vmsensitiveword', hasdetail: false, ico: 'levan.ico', parentId: 2, active: false, module: 7 }
        ],
        agent: [{ id: 1, title: '代理管理', sid: '', href: '#', view: '', vm: '', hasdetail: false, ico: 'icon-daili', parentId: 0, active: false, open: true, animation: 'enter' },
            { id: 101, title: '代理信息', sid: 'info', href: '#!/info', view: 'info.html', vm: 'vminfo', hasdetail: false, ico: 'levan.ico', parentId: 1, active: false, module: 1 },
            { id: 102, title: '代理商帐号', sid: 'subagentlist', href: '#!/subagentlist', view: 'subagentlist.html', vm: 'vmsubagentlist', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 2 },
            { id: 103, title: '操作日志', sid: 'log', href: '#!/log', view: 'log.html', vm: 'vmlog', hasdetail: false, ico: 'levan.ico', parentId: 1, active: false, module: 6 },
        ]
    },
    loadViews: function (isagent) {
        if (isagent) {
            vmMenu.datasource = vmMenu.viewdata.agent;
        }
        else {
            vmMenu.datasource = vmMenu.viewdata.admin;
        }
    },
    getMenus: function () {
        if (vmMenu.menuArr.$model.length === 0) {
            vmMenu.menuArr.clear();
            var ms = [];
            var dsm = vmMenu.datasource.$model;
            for (var i = 0, len = dsm.length; i < len; i++) {
                var v = dsm[i];
                if (v.parentId === 0) {
                    ms.push(v);
                }
            };
            vmMenu.menuArr = ms;
        }
    },
    subMenuFilter: function (el) {
        
    },
    showSubMenu: function (m) {
        m.animation = m.animation !== 'leave' ? 'leave' : 'enter';
    },
    getSubmenus: function (pid) {
        var sms = [];
        var dsm = vmMenu.datasource.$model;
        for (var i = 0, len = dsm.length; i < len; i++) {
            var v = dsm[i];
            if (v.parentId === pid) {
                sms.push(v);
            }
        };
        return sms;
    },
    onSelect: function (item) {
        var dsm = vmMenu.datasource.$model;
        var currIndex;

        for (var i = 0, len = dsm.length; i < len; i++) {
            var v = dsm[i];
            if (v.sid == item.sid) {
                currIndex = i;
            }
        };

        vmMenu.datasource[vmMenu.selectedItemIndex].active = false;
        vmMenu.datasource[currIndex].active = true;

        //item.active = true;
        vmMenu.selectedItem = item;
        vmMenu.selectedItemIndex = currIndex;

        //填充数据到右边tab数组
        vmView.changeViewsTab(item);

        var getsid = item.sid;
        if (getsid == "subagentlist") {
            vmsubagentlist.findNew();
        }
        if (getsid == "admin") {
            vmadmin.findNew();
        }
        if (getsid == "roles") {
            vmroles.findNew();
        }
        if (getsid == "log") {
            vmlog.findNew();
            vmlog.getOperations();
        }
        if (getsid == "sensitiveword") {
            vmsensitiveword.findNew();
        }
         
    },
    toggle: false,
    toggleClass: function () {
        vmMenu.toggle = !vmMenu.toggle;
        if (vmView.toggleClass) {
            vmView.toggleClass();
        }
    }
});

var vmroles = avalon.define({
    $id: 'vmroles',
    moduleType: 4,
    table: '',
    vmState: 'none',
    editBoxTitle: '新增角色',
    dialogAddAnimation: 'enter',
    dialogEditAnimation: 'enter',
    IsFind: 0,
    closeAddDialog: function (e) {
        vmroles.dialogAddAnimation = 'enter';
    },
    closeEditDialog: function (e) {
        vmroles.dialogEditAnimation = 'enter';
    },
    openAddDialog: function (e) {
        var now = new Date().Format('yyyy-MM-dd');

        var newrole = { RoleID: 0, RoleName: '', Description: '', Operator: app.LoginUser.UserName, Created: now, Modified: now };
        vmroles.newRole = newrole;
        vmroles.editBoxTitle = '新增角色';
        vmroles.dialogAddAnimation = 'leave';
        vmroles.vmState = 'add';
    },
    openEditDialog: function (e) {
        if (vmroles.selectedRowIndex == -1) {
            MessageBox.error('没有选中行！');
            return false;
        }
        vmroles.editBoxTitle = '新增角色';
        vmroles.selectedRole.Operator = app.LoginUser.UserName;
        vmroles.selectedRole.Modified = new Date().Format('yyyy-MM-dd');
        vmroles.dialogEditAnimation = 'leave';
        vmroles.vmState = 'edit';
    },
    datasource: [],
    datasource2: [],
    columns: [],
    newRole: { RoleID: '', RoleName: '', Description: '', AgentLevel: 1, Operator: '', Created: '', Modified: '' },
    selectedRole: { RoleID: '', Operator: '', RoleName: '', Description: '', Created: new Date().Format('yyyy-MM-dd'), Modified: new Date().Format('yyyy-MM-dd') },
    //selectedRole: { checked: false, selected: false, RoleID: '', RoleName: '', Description: '', AgentLevel: 1, Operator: '', Created: new Date().Format('yyyy-MM-dd'), Modified: new Date().Format('yyyy-MM-dd') },
    selectedRowIndex: -1,
    onNewRoleChanged: function (i, r) {
        if (i === vmroles.selectedRowIndex) return;

        if (vmroles.selectedRowIndex !== -1) {
            vmroles.datasource[vmroles.selectedRowIndex].selected = false;
        }
        vmroles.datasource[i].selected = true;

        vmroles.selectedRowIndex = i;
        vmroles.selectedRole.RoleID = r.RoleID;
        vmroles.selectedRole.RoleName = r.RoleName;
        vmroles.selectedRole.Description = r.Description;
        vmroles.selectedRole.Created = new Date(r.Created).Format('yyyy-MM-dd');
    },
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmroles.moduleType;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;

        Du.Loading('Roles', 'Index', querystring, function (data) {
            vmroles.datasource = data.result.data;
            vmroles.datasource2 = data.result.data;
            vmroles.config.totalPage = data.result.totalPage;
            vmroles.config.totalCount = data.result.totalCount;
        });
    },
    findNew: function () {
        if (vmroles.IsFind == 0) {
            vmroles.IsFind = 1;
            vmroles.config.pageIndex = 1;
            vmroles.fillGrid({ pageIndex: 1, pageSize: vmroles.config.pageSize });
        }
    },
    find: function () {
        vmroles.config.pageIndex = 1;
        vmroles.fillGrid({ pageIndex: 1, pageSize: vmroles.config.pageSize });
    },
    submit: function (e) {
        var querystring = '&moduleType=' + vmroles.moduleType;
        var data = $(e.target).serialize();
        var type = '';
        if (vmroles.vmState == 'add') {
            type = 'New';
        }
        else if (vmroles.vmState == 'edit') {
            type = 'Edit';
        }

        Du.PostFormData('Roles', type, querystring, data, function (data) {
            vmroles.closeAddDialog();
            vmroles.closeEditDialog();
            vmroles.refresh();
            MessageBox.show(data);
        });
    },
    getIds: function () {
        var ids = '';
        var dm = vmroles.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i].RoleID;
            }
        }
        return ids.substring(1, ids.length);;
    },
    del: function () {
        var ids = vmroles.getIds();
        if (ids === '') {
            MessageBox.error("请先勾选行！");
            return false;
        }
        var querystring = '&moduleType=' + vmroles.moduleType;
        querystring += '&ids=' + ids;
        Du.Post('Roles', 'Delete', querystring, function (data) {
            vmroles.refresh();
            MessageBox.show(data);
        });
    },
    refresh: function () {
        vmroles.config.pageIndex = 1;
        vmroles.fillGrid({ pageIndex: 1, pageSize: vmroles.config.pageSize });
    },
    init: function () {
        vmroles.refresh();
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    sortDesc: function (col) {
        if (vmroles.selectedRowIndex !== -1) {
            vmroles.datasource[vmroles.selectedRowIndex].selected = false;
        }
        vmroles.datasource.sort(function (a, b) {
            if (col == 'Created' || col == 'Modified') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmroles.selectedRowIndex !== -1) {
            vmroles.datasource[vmroles.selectedRowIndex].selected = false;
        }
        vmroles.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'Created' || col == 'Modified') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmroles.datasource.forEach(function (el) {
            if (el.RoleID != 1) {
                el.checked = checked;
            }
        });
    },
    checkOne: function (e) {

        var checked = e.target.checked
        if (checked === false) {
            vmroles.allchecked = false
        } else {
            vmroles.allchecked = vmroles.datasource.every(function (el) {
                return el.checked
            })
        }
    }
});

var vmsensitiveword = avalon.define({
    $id: 'vmsensitiveword',
    moduleType: 7,
    vmState: 'none',
    condition: { keyword: '' },
    selectedRow: {},
    selectedRowIndex: -1,
    datasource: [],
    IsFind: 0,
    onGridSelectedRowChanged: function (i, r) {
        if (i === vmsensitiveword.selectedRowIndex) return;

        if (vmsensitiveword.selectedRowIndex !== -1) {
            vmsensitiveword.datasource[vmsensitiveword.selectedRowIndex].selected = false;
        }
        vmsensitiveword.datasource[i].selected = true;

        vmsensitiveword.selectedRowIndex = i;
        vmsensitiveword.selectedRow = r;
        //vmsensitiveword.selectedRow.LastTime = new Date(r.LastTime).Format('yyyy-MM-dd HH:mm:ss');
    },
    /***********注入grid的方法**************/
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&keyword=' + vmsensitiveword.condition.keyword;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;

        Du.Get('SensitiveWord', 'Index', querystring,
            function (data) {
                vmsensitiveword.datasource = data.result.data;
                vmsensitiveword.config.totalPage = data.result.totalPage;
                vmsensitiveword.config.totalCount = data.result.totalCount;
                if (vmsensitiveword.selectedRowIndex != -1) {
                    vmsensitiveword.datasource[vmsensitiveword.selectedRowIndex].selected = true;
                }
            });
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    findNew: function () {
        if (vmsensitiveword.IsFind == 0) {
            vmsensitiveword.IsFind = 1;
            vmsensitiveword.config.pageIndex = 1;
            vmsensitiveword.fillGrid({ pageIndex: 1, pageSize: vmsensitiveword.config.pageSize });
        }
    },
    find: function () {
        vmsensitiveword.config.pageIndex = 1;
        vmsensitiveword.fillGrid({ pageIndex: 1, pageSize: vmsensitiveword.config.pageSize });
    },
    refresh: function () {
        vmsensitiveword.fillGrid({ pageIndex: vmsensitiveword.config.pageIndex, pageSize: vmsensitiveword.config.pageSize });
    },
    reset: function () {
        vmsensitiveword.condition = { keyword: '', status: -1 };
    },
    editpage: 'none',
    addAnimation: 'enter',
    editAnimation: 'enter',
    showAddDialog: function (e) {
        vmsensitiveword.addAnimation = 'leave';
        vmsensitiveword.newModel = { SensitiveWord: '', LastTime: new Date().Format('yyyy-MM-dd HH:mm:ss') };

    },
    showEditDialog: function (r) {
        vmsensitiveword.editAnimation = 'leave';
        vmsensitiveword.editModel.ID = r.ID;
        vmsensitiveword.editModel.SensitiveWord = r.SensitiveWord;
        vmsensitiveword.editModel.LastTime = new Date().Format('yyyy-MM-dd HH:mm:ss');
    },
    closeAddDialog: function (e) {
        vmsensitiveword.addAnimation = 'enter';
    },
    closeEditDialog: function (e) {
        vmsensitiveword.editAnimation = 'enter';
    },
    newModel: { SensitiveWord: '', LastTime: '' },
    editModel: { ID: -1, SensitiveWord: '', OldSensitiveWord: '', LastTime: '' },
    addSubmit: function (e) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&' + $(e.target).serialize();
        console.log(querystring);
        Du.Post('SensitiveWord', 'New', querystring,
            function (data) {
                if (data.status == 'success') {
                    vmsensitiveword.closeAddDialog();
                }
                MessageBox.show(data);
                vmsensitiveword.refresh();
            });
    },
    editSubmit: function (e) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&' + $(e.target).serialize() + '&OldSensitiveWord' + vmsensitiveword.editModel.OldSensitiveWord;
        Du.Post('SensitiveWord', 'Edit', querystring,
            function (data) {
                if (data.status == 'success') {
                    vmsensitiveword.closeEditDialog();
                }
                MessageBox.show(data);
                vmsensitiveword.refresh();
            });
    },
    del: function (id) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&ids=' + id;
        Du.Post('SensitiveWord', 'Delete', querystring,
            function (data) {
                MessageBox.show(data);
                vmsensitiveword.selectedRowIndex = -1;
                vmsensitiveword.refresh();
            });
    },
    delS: function () {
        var ids = vmsensitiveword.checkIds();
        if (!ids) {
            MessageBox.error("请先勾选行");
            return;
        }
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&ids=' + ids;
        Du.Post('SensitiveWord', 'Delete', querystring,
            function (data) {
                MessageBox.show(data);
                vmsensitiveword.selectedRowIndex = -1;
                vmsensitiveword.refresh();
            });
    },
    getIds: function (idname) {
        var ids = '';
        var dm = vmsensitiveword.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i][idname];
            }
        }
        return ids.substring(1, ids.length);;
    },
    checkIds: function () {
        var ids = vmsensitiveword.getIds('ID');
        return ids;
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        this.datasource.forEach(function (el) {
            el.checked = checked
        });
        this.setSkipChecked();
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            this.allchecked = false
        } else {
            this.allchecked = this.datasource.every(function (el) {
                return el.checked
            })
        }
    },
    init: function () {
        vmsensitiveword.find();
    }
});
var vmspreaderoptions = avalon.define({
    $id: 'vmspreaderoptions',
    moduleType: 5,
    AgentRoles: [],
    AgentGrades: [],
    ggOption: { RoleID: -1, GradeID: -1, TotalSpreaderRate: '', ASpreaderRate: '', BSpreaderRate: '', CSpreaderRate: '' },
    pgOption: { RoleID: -1, GradeID: -1, TotalSpreaderRate: '', ASpreaderRate: '', BSpreaderRate: '', CSpreaderRate: '' },
    bindData: function () {
        var querystring = '&moduleType=' + vmspreaderoptions.moduleType;
        querystring += '&subType=binddata';
        Du.Get('Spreaderoptions', 'Index', querystring, function (data) {
            MessageBox.success(data);
            vmspreaderoptions.AgentRoles = data.result.AgentRoles;
            vmspreaderoptions.AgentGrades = data.result.AgentGrades;
        });
    },
    bindGradesFilter: function (el) {
        return el.RoleID == vmspreaderoptions.ggOption.RoleID;
    },
    SpreadOptionsSet: [],
    AgentRevenesSet: [],
    getAgentSpreaderOptionList: function () {
        var querystring = '&moduleType=' + vmspreaderoptions.moduleType;
        Du.Get('Spreaderoptions', 'Index', querystring, function (data) {
            MessageBox.success(data);
            vmspreaderoptions.SpreadOptionsSet = data.result.SpreadOptionsSet;
            vmspreaderoptions.AgentRevenesSet = data.result.AgentRevenesSet;
        });
    },
    submit: function (e) {
        var querystring = '&moduleType=' + vmspreaderoptions.moduleType;
        var list, subType;
        if (e === 0) {
            list = vmspreaderoptions.SpreadOptionsSet.$model;
            querystring += '&subType=spreadoptionsset';
        }
        else {
            list = vmspreaderoptions.AgentRevenesSet.$model;
            querystring += '&subType=agentrevenesset';
        }

        var data = JSON.stringify(list);
        Du.PostFormData('Spreaderoptions', 'New', querystring, data, function (data) {
            MessageBox.show(data);
        });
    },
    GetColor: function (des) {
        var color;
        switch (des) {
            case '金牌1':
                color = '#886600';
                break;
            case '金牌2':
                color = '#AA7700';
                break;
            case '金牌3':
                color = '#DDAA00';
                break;
            case '金牌4':
                color = '#FFBB00';
                break;
            case '金牌5':
                color = '#FFCC22';
                break;
            case '银牌1':
                color = '#0088A8';
                break;
            case '银牌2':
                color = '#009FCC'
                break;
            case '银牌3':
                color = '#00BBFF';
                break;
            case '银牌4':
                color = '#33CCFF';
                break;
            case '银牌5':
                color = '#77DDFF';
                break;
        }
        return color;
    },
    init: function () {
        vmspreaderoptions.getAgentSpreaderOptionList();
    }
});
var vmsubagentlist = avalon.define({
    $id: 'vmsubagentlist',
    moduleType: 2,
    condition: { keyword: '', status: -1 },
    datasource: [],
    columns: [],
    selectedRowIndex: -1,
    selectedRow: {},
    model: { UserID: -1, UserName: '', oriPassword: '', Password: '', cfPassword: '', IsBand: false, BandIP: '0.0.0.0', RoleID: -1, Nullity: -1 },
    roles: [],
    grades: [],
    IsFind: 0,
    changeStatus: function (e) {
        vmsubagentlist.condition.status = e.target.value;
    },
    /***********注入grid的方法**************/
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&keyword=' + vmsubagentlist.condition.keyword + '&status=' + vmsubagentlist.condition.status + '&IsAgent=' + app.LoginUser.IsAgent;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;
        Du.Get('SubAgents', 'Index', querystring, function (data) {
            vmsubagentlist.datasource = data.result.data;
            vmsubagentlist.config.totalPage = data.result.totalPage;
            vmsubagentlist.config.totalCount = data.result.totalCount;
        });
    },
    findNew: function () {
        if (vmsubagentlist.IsFind == 0) {
            vmsubagentlist.IsFind = 1;
            vmsubagentlist.config.pageIndex = 1;
            vmsubagentlist.fillGrid({ pageIndex: 1, pageSize: vmsubagentlist.config.pageSize });
        }
    },
    find: function () {
        vmsubagentlist.config.pageIndex = 1;
        vmsubagentlist.fillGrid({ pageIndex: 1, pageSize: vmsubagentlist.config.pageSize });
    },
    /****************注入grid方法******************/
    onGridSelectedRowChanged: function (i, r) {
        if (i === vmsubagentlist.selectedRowIndex) return;

        if (vmsubagentlist.selectedRowIndex !== -1) {
            vmsubagentlist.datasource[vmsubagentlist.selectedRowIndex].selected = false;
        }
        vmsubagentlist.datasource[i].selected = true;

        vmsubagentlist.model.UserID = r.UserID;
        vmsubagentlist.model.UserName = r.UserName;
        vmsubagentlist.model.Password = '';
        vmsubagentlist.model.cfPassword = '';
        vmsubagentlist.model.IsBand = r.IsBand;
        vmsubagentlist.model.BandIP = r.BandIP;
        vmsubagentlist.model.RoleID = r.RoleID;
        vmsubagentlist.model.Nullity = r.Nullity;

        vmsubagentlist.selectedRowIndex = i;
        vmsubagentlist.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    reset: function () {
        vmsubagentlist.condition = { keyword: '', status: -1 };
    },
    /*************************************/
    closePwdDialog: function () {
        vmsubagentlist.pwdAnimation = 'enter';
        return false;
    },
    pwdAnimation: 'enter',
    openPwdDialog: function () {
        if (vmsubagentlist.selectedRowIndex == -1) {
            alert('没有选中行！');
            return false;
        }
        vmsubagentlist.pwdAnimation = 'leave';
        return false;
    },
    changePwd: function () {
        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=ch_pwd';
        querystring += '&UserID=' + vmsubagentlist.model.UserID + '&UserName=' + vmsubagentlist.model.UserName;
        Du.Post('SubAgents', 'Edit', querystring, function (data) {
            if (data.status == 'success') {
                vmsubagentlist.closePwdDialog();
            }
            MessageBox.show(data);
        });

        return false;
    },
    submit: function (formid) {
        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=' + vmsubagentlist.vmState;
        Du.PostFormData('SubAgents', 'Edit', querystring, $(e.target).serialize(), function (data) {
            if (data.status == 'success') {
                vmsubagentlist.closePwdDialog();
            }
            MessageBox.show(data);
        });
    },
    getIds: function () {
        var ids = '';
        var dm = vmsubagentlist.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i].UserID;
            }
        }

        return ids.substring(1, ids.length);;
    },
    dj: function (e) {
        ids = vmsubagentlist.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=dj&ids=' + ids;
        Du.Post('SubAgents', 'Edit', querystring, function (data) {
            MessageBox.show(data);
            vmsubagentlist.find();
        });
    },
    jd: function (e) {
        ids = vmsubagentlist.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=jd&ids=' + ids;
        Du.Post('SubAgents', 'Edit', querystring, function (data) {
            MessageBox.show(data);
            vmsubagentlist.find();
        });

        return false;
    },
    getBindData: function () {
        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=binddata';
        Du.Post('SubAgents', 'Index', querystring, function (data) {
            MessageBox.success(data);
            var roles = data.result.AgentRoles;
            vmsubagentlist.roles = data.result.AgentRoles;
            vmsubagentlist.grades = data.result.AgentGrades;
        });
    },
    getAgentGrades: function () {

    },
    init: function () {
        //vmInfo.getBindData();
        vmsubagentlist.find();
    },
    sort: function (col) {
        vmsubagentlist.datasource.sort(function (a, b) {
            return a[col] > b[col];
        });
    },
    gridsorticon: false,
    toggleGridSortBtn: function () {
        vmsubagentlist.gridsorticon = !vmsubagentlist.gridsorticon;
        vmsubagentlist.ToBig;
    },
    sortDesc: function (col) {
        if (vmsubagentlist.selectedRowIndex !== -1) {
            vmsubagentlist.datasource[vmsubagentlist.selectedRowIndex].selected = false;
        }
        vmsubagentlist.datasource.sort(function (a, b) {
            if (col == 'LastLogintime') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmsubagentlist.selectedRowIndex !== -1) {
            vmsubagentlist.datasource[vmsubagentlist.selectedRowIndex].selected = false;
        }
        vmsubagentlist.datasource.sort(function (a, b) {
            if (col == 'LastLogintime') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmsubagentlist.datasource.forEach(function (el) {
            el.checked = checked
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmsubagentlist.allchecked = false
        } else {
            vmsubagentlist.allchecked = vmsubagentlist.datasource.every(function (el) {
                return el.checked
            })
        }
    },
    GetColor: function (des) {
        var color;
        switch (des) {
            case '金牌1':
                color = '#886600';
                break;
            case '金牌2':
                color = '#AA7700';
                break;
            case '金牌3':
                color = '#DDAA00';
                break;
            case '金牌4':
                color = '#FFBB00';
                break;
            case '金牌5':
                color = '#FFCC22';
                break;
            case '银牌1':
                color = '#0088A8';
                break;
            case '银牌2':
                color = '#009FCC'
                break;
            case '银牌3':
                color = '#00BBFF';
                break;
            case '银牌4':
                color = '#33CCFF';
                break;
            case '银牌5':
                color = '#77DDFF';
                break;
        }
        return color;
    }

});

var vmView = avalon.define({
    $id: 'view',
    viewtabs: [],
    onSelect: function (i, vt) {
        if (vmView.selectedTab.sid !== vt.sid) {
            var preIndex = vmView.selectedTabIndex;
            var currIndex = i;

            vmView.viewtabs[preIndex].active = false;
            vmView.viewtabs[currIndex].active = true;
            var newVt = vt.$model;
            newVt.active = true;
            vmView.selectedTab = newVt;
            vmView.selectedTabIndex = currIndex;
        }
    },
    selectedTabIndex: 0,
    selectedTab: {},
    tabContents: [],
    changeViewsTab: function (v) {
        var has = false;
        var currIndex = 0;

        var vtm = vmView.viewtabs.$model;
        if (vtm.length === 0) {
            has = false;
        }
        else {
            for (var i = 0, len = vtm.length; i < len; i++) {
                var vt = vtm[i];
                if (vt.sid == v.sid) {
                    currIndex = i;
                    has = true;
                    break;
                }
            }
        }

        if (!has) {//如果还没打开，则打开
            var htmlurl = '/views/' + v.view;
            $.get(htmlurl, function (data) {
                if (vmView.viewtabs.length > 0)
                    vmView.viewtabs[vmView.selectedTabIndex].active = false;

                var currIndex = vmView.viewtabs.length,
                    preIndex = vmView.selectedTabIndex;
                vmView.selectedTabIndex = currIndex;

                data = data.replace('#vmodel#', v.vm);
                var tab = { sid: v.sid, href: v.href, title: v.title, view: data, vm: v.vm, active: true };
                vmView.selectedTab = tab;
                vmView.viewtabs.ensure(tab);
                vmView.tabContents.push(data);
                
            });
        }
        else {
            var preIndex = vmView.selectedTabIndex
            vmView.viewtabs[vmView.selectedTabIndex].active = false;
            vmView.viewtabs[currIndex].active = true;
            vmView.selectedTabIndex = currIndex;
            vmView.selectedTab = vmView.viewtabs.$model[currIndex];//如果已打开，则根据索引号设置选择
            
        }
    },
    onMouseOver: function (e) {
        $(e.target).children('.iconfont').addClass('over');
    },
    onMouseOut: function (e) {
        $(e.target).children('.iconfont').removeClass('over');
    },
    remove: function (i, vt) {
        var active = vt.active;
        vmView.viewtabs.removeAt(i);
        delete avalon.vmodels[vt.vm];
        vmView.tabContents.removeAt(i);

        if (vmView.viewtabs.$model.length === 0) {
            vmView.viewtabs = [];
            vmView.tabContents = [];
        }

        if (vmView.viewtabs.length > 0) {
            var currIndex = 0;
            if (active) {
                //如果关闭的tab是当前选中的，则选中项移到第一个tab
                currIndex = 0;
            }
            else if (i < vmView.selectedTabIndex) {
                //如果移除的tab索引少于当前索引,则当前索引应当-1
                var currIndex = vmView.selectedTabIndex - 1;
            }
            vmView.viewtabs[currIndex].active = true;
            vmView.selectedTab = vmView.viewtabs.$model[currIndex];
            vmView.selectedTabIndex = currIndex;
        }
        else {
            vmView.selectedTab = {};
            vmView.selectedTabIndex = -1;
        }
    },
    toggle: false,
    toggleClass: function () {
        vmView.toggle = !vmView.toggle;
    }
});
