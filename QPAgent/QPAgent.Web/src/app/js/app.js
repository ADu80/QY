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

