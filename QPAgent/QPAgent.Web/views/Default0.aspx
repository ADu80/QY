<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default0.aspx.cs" Inherits="QPAgent.Web.Default" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>棋游代理 - 主页</title>
    <link href="/icofont/iconfont.css" rel="stylesheet" />
    <link href="/build/vendor/jquery/jquery-datepicker.min.css" rel="stylesheet" />
    <!--inject:css-->
    <!--endinject-->
    <script src="/build/vendor/jquery/jquery.js"></script>
    <script src="/build/vendor/jquery/jquery-extend.js"></script>
    <script src="/build/vendor/avalon/avalon-2.2.4.js"></script> 
    <script>
        avalon.config({
            debug: false
        });

        $(document).ready(function () {
            $('#logout').click(function () {
                $.post('/ajaxLogin.ashx?type=logout', { username: 'admin' }, function (data) {
                    window.location.href = '/Login.aspx';
                });
            });
        });
    </script>
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
<body ms-controller="app" oncontextmenu="return false" ms-click="@hideLoginInfoListBox($event,'login-info-pwd')">
    <div class="header">
        <h1>
            <img src="/img/favicon.ico" /><span>代理系统</span></h1>
        <div class="navigator">
            <div class="login-info">
                <div class="item">
                    <span class="iconfont icon-ren"></span>
                    <span ms-mouseenter="@openLoginInfoListBox">{{@LoginUser.UserName+'('+@LoginUser.RoleName+')'}}</span>
                    <span class="iconfont icon-up" ms-click="@openLoginInfoListBox"></span>
                </div>
                <div class="item"><span class="iconfont icon-qianjin"></span><a class="logout" id="logout" href="#">退出</a></div>
            </div>
        </div>
        <div class="login-info-list" ms-visible="@loginInfoListBoxVisible"><a ms-click="@openChangePwdDialog"><span class="iconfont icon-xiugai"></span>修改密码</a></div>
    </div>
    <div class="body">
        <div ms-important="menu" ms-class="['nav',@toggle&&'toggle']">
            <div class="nav-title">
                <h2>导航列表<span ms-class="['iconfont',@toggle?'icon-roundright':'icon-roundleft']" ms-click="@toggleClass()"></span></h2>
            </div>
            <ul class="menu">
                <li class="item" ms-for="(i,m) in @menuArr">
                    <div class="title" ms-click="@showSubMenu(m) | stop">
                        <a ms-attr="{id:m.sid}"><span ms-class="['iconfont',m.ico]"></span><span>{{m.title}}</span><span ms-class="['iconfont',m.open?'icon-jiantou-down':'icon-jiantou-right']"></span></a>
                    </div>
                    <%--<ul class="submenu" ms-visible="m.open">--%>
                    <ul class="submenu" ms-effect="{is:'slide',action:m.animation,onEnterDone: @slideEnterDone,onLeaveDone: @slideLeaveDone}">
                        <li class="item" ms-for="(j,sm) in @getSubmenus(m.id)"><a ms-class="sm.active && 'active'" ms-attr="{id:sm.sid}" ms-click="@onSelect(sm)"><span>{{sm.title}}</span></a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div ms-controller="view" ms-class="['viewpage',@toggle&&'toggle']">
            <div class="viewtab">
                <ul class="tab-header">
                    <li ms-for="(i,vt) in @viewtabs">
                        <%--<a ms-class="vt.active && 'active'" ms-attr="{id:vt.sid}" ms-click="@onSelect(i,vt)" ms-on-mouseenter="@onMouseOver" ms-on-mouseleave="@onMouseOut"><span>{{vt.title}}</span><span class="iconfont icon-cha" ms-click="@remove(i,vt) | stop"></span></a>--%>
                        <a ms-class="vt.active && 'active'" ms-attr="{id:vt.sid}" ms-click="@onSelect(i,vt)"><span>{{vt.title}}</span></a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div ms-for="(i,t) in @tabContents" ms-attr="{id:'page'+i}" ms-html="t" ms-class="['page',@selectedTabIndex===i&&'visible']"></div>
                </div>
            </div>
        </div>
    </div>
    <div class="footer">
        <div class="container-full">
            <div class="msgbox error">
                <label></label>
            </div>
            <div class="time"><span>当前登录用户：<span id="username">{{@LoginUser.UserName}}</span>({{@LoginUser.RoleName}})</span><span class="fg">|</span><span>登录时间：{{@loginTimeStr}}</span><span class="fg">|</span><span>已登录：{{@loginLongStr}}</span></div>
        </div>
    </div>
    <!--右键菜单-->
    <div class="lev-contextmenu">
        <ol class="main">
            <li class="item item-agent">
                <div class="title"><span class="title-text">代理</span><span class="iconfont icon-right"></span></div>
                <ol class="sub">
                    <li class="subitem">
                        <div class="action"><span class="title-text">新增</span></div>
                    </li>
                </ol>
            </li>
            <li class="item item-gamer">
                <div class="title"><span class="title-text">玩家</span><span class="iconfont icon-right"></span></div>
                <ol class="sub">
                    <li class="subitem">
                        <div class="action"><span class="title-text">新增</span></div>
                    </li>
                </ol>
            </li>
            <li class="item item-setting">
                <div class="title"><span class="title-text">设置</span><span class="iconfont icon-right"></span></div>
                <ol class="sub">
                    <li class="subitem">
                        <div class="action"><span class="title-text">属性</span></div>
                    </li>
                </ol>
            </li>
            <li class="item item-refresh">
                <div class="title"><span class="title-text">刷新</span></div>
            </li>
        </ol>
    </div>
    <div class="login-info-pwd" ms-visible="@changePwdDialogVisible">
        <div class="box-header">修改密码</div>
        <form id="form_app_chpwd" ms-on-submit="@changePwd($event);return false;">
            <div class="row">
                <label class="md">原密码：</label><input type="password" name="oldPwd" ms-duplex-value="@PwdForm.oldPwd" /><input type="text" class="nodisplay" name="UserID" ms-duplex-value="@LoginUser.UserID" />
            </div>
            <div class="row">
                <label class="md">新密码：</label><input type="password" name="newPwd" ms-duplex-value="@PwdForm.newPwd" />
            </div>
            <div class="row">
                <label class="md">确认新密码：</label><input type="password" name="cfmPwd" ms-duplex-value="@PwdForm.cfmPwd" />
            </div>
            <div class="row textcenter">
                <button class="btn" type="submit">保存</button>
                <a type="button" class="btn" ms-click="@closeChangePwdDialog">取消</a>
            </div>
        </form>
    </div>

    <!--inject:js-->
    <!--endinject-->
</body>
</html>
