<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="recruit.aspx.cs" Inherits="Game.Web.Introduce.recruit" %>

<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>广州棋游-公司简介</title>
    <link href="/style/Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <%--<link href="/style/global_new.css" rel="stylesheet" />--%>
    <link href="/style/company.css" rel="stylesheet" />
    <script src="/style/Bootstrap/js/jquery-3.1.1.min.js"></script>
    <script src="/style/Bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
    <nav class="header navbar navbar-inverse" role="navigation">
        <div><a href="/Default.aspx" class="backwww">返回游戏官网</a></div>
        <div class="container-fluid container">
            <div class="navbar-header">
                <a class="navbar-brand" href="/Introduce/Company.aspx">关于我们</a>
            </div>
            <div>
                <ul class="nav navbar-nav">
                    <li><a href="/Introduce/introduce.aspx">公司简介</a></li>
                    <li><a href="/Introduce/events.aspx">活动风采</a></li>
                    <li><a href="/Introduce/contact.aspx">联系我们</a></li>
                    <li><a href="/Introduce/recruit.aspx">招聘信息</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="webpath">
        <ol class="breadcrumb container">
            <li><a href="/Introduce/Company.aspx">关于我们</a></li>
            <li class="active">招聘信息</li>
        </ol>
    </div>
    <div class="content graybg">
    </div>

    <qp:Footer ID="sFooter" runat="server" />

    <script src="/js/levan.introduce.js"></script>
</body>
</html>
