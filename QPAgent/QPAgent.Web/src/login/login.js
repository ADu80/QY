var validForm = (function () {
    return {
        init: function () {
            var vcode = ValidateState.createCode();
            $('label.vcode').text(vcode);

            ValidateState.pushValidateItem('username', false, '用户名格式不正确');
            ValidateState.pushValidateItem('password', false, '密码不能包含空格，长度不少6，不超过20');
            ValidateState.pushValidateItem('vcode', false, '验证码输入错误');
        },
        checkAll: function () {
            var r = ValidateState.checkuser($('input[name="username"]').val().trim());
            ValidateState.pushValidateItem('username', r.status, r.msg);

            r = ValidateState.checkpassword($('input[name="password"]').val());
            ValidateState.pushValidateItem('password', r.status, r.msg);

            r = ValidateState.validateCode($('input[name="vcode"]').val());
            ValidateState.pushValidateItem('vcode', r.status, r.msg);
        }
    }
})();
$(document).ready(function () {
    validForm.init();
    //背景图片
    $('.bg').height($(window).height());
    $(window).resize(function () {
        $('.bg').height($(window).height());
    });
    //异步提交登录请求
    $('#form1').bind('submit', function (e) {
        e.preventDefault();
        //表单验证
        validForm.checkAll();
        var r = ValidateState.validateAll();
        if (!r.status) {
            MessageState.Show('#lblmsg', r.msg);
            return false;
        }
        $('#btnsumbit').val('正在登录...');
        $('#btnsumbit').attr('disabled', 'disabled');
        $.ajax({
            url: 'ajaxLogin.ashx?type=login',
            method: 'POST',
            data: $(this).serialize(),
            success: function (data) {
                if (data.status == 'success') {
                    window.location.href = "/";
                }
                else {
                    MessageState.Show('#lblmsg', data.message);
                    alert(data.message);
                    $('#btnsumbit').val('登录');
                    $('#btnsumbit').removeAttr('disabled');
                }
            },
            error: function (err) {
                alert(err.responseText);
                MessageState.Show('#lblmsg', err.responseText);
                $('#btnsumbit').val('登录');
                $('#btnsumbit').removeAttr('disabled');
            }
        });
        return false;
    });

    $('#username').focus();

    //验证码
    $('label.vcode').click(function () {
        var vcode = ValidateState.createCode();
        $('label.vcode').text(vcode);
    });
    $('input[name="username"]').change(function () {
        var r = ValidateState.checkuser($(this).val().trim());
        if (!r.status) {
            MessageState.Show('#lblmsg', r.msg);
        }
    });
    $('input[name="password"]').change(function () {
        var r = ValidateState.checkpassword($(this).val());
        if (!r.status) {
            MessageState.Show('#lblmsg', r.msg);
        }
    });
    $('input[name="vcode"]').change(function () {
        var r = ValidateState.validateCode($(this).val());
        if (!r.status) {
            MessageState.Show('#lblmsg', r.msg);
        }
    });
});
