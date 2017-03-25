// JavaScript Document

$(document).ready(function (e) {
    $('#loginform').submit(function (e) {
        e.preventDefault();
        dd.Post('/Accounts/Index', $(e.target).serialize(),
            function (data) {
                //data=JSON.stringify(data)
                var msg = data.message;
                if (msg == "登录成功！") {
                    window.location.href = "index.html";
                } else {
                    alert("该用户不存在！");
                }
            },
            function () {
                alert('失败')
            }
        );
    });
});

