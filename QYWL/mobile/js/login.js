
$(document).ready(function (e) {
    $('#loginform').submit(function (e) {
        $.ajax({
            url: 'http://117.78.46.33:8057/api/Accounts/Index',
            method: 'POST',
            dataType: 'jsonp',
            jsonp: 'jsonpcb',
            data: $(e.target).serialize(),
            success: function (data) {
                //data=JSON.stringify(data)
				var msg=eval(data).message;
				if(msg=="登录成功！"){
					confirm("欢迎回来")	
					window.location.href="index.html";
				}else{	
					confirm("该用户不存在！");
				}
            },
            error: function () {
                alert('失败')
            }
        });
        return false;
    });
});

