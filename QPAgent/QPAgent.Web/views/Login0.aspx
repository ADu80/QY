<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QPAgent.Web.Login" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>棋游代理 - 登录界面</title>
    <!--inject:css-->
    <!--endinject-->
    <script src="/build/vendor/jquery/jquery.js"></script>
    <!--inject:js-->
    <!--endinject-->
    <script>
        //处理键盘事件
        function doKey(e) {
            var ev = e || window.event; //获取event对象   
            var obj = ev.target || ev.srcElement; //获取事件源   
            var t = obj.type || obj.getAttribute('type'); //获取事件源类型   
            if (ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea") {
                return false;
            }
        }
        //禁止后退键 作用于Firefox、Opera ,360  
        document.onkeypress = doKey;
        //禁止后退键  作用于IE、Chrome   
        document.onkeydown = doKey;
    </script>
</head>
<body>
    <div class="bg"></div>
    <h1>棋游代理平台</h1>
    <div class="loginbox">
        <form id="form1" runat="server">
            <div class="row">
                <div class="col">
                    <label>用户名：</label>
                </div>
                <div class="col">
                    <input id="username" type="text" name="username" />
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <label>密码：</label>
                </div>
                <div class="col">
                    <input type="password" name="password" />
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <label>验证码：</label>
                </div>
                <div class="col">
                    <input class="vcode" type="text" name="vcode" /><label class="vcode"></label>
                </div>
            </div>
            <div class="row btnbox">
                <input id="btnsumbit" type="submit" value="登录" /><label id="lblmsg"></label>
            </div>
        </form>
    </div>
    <script>
    </script>
</body>
</html>
