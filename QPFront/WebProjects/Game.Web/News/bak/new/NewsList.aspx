<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewsList.aspx.cs" Inherits="Game.Web.News.NewsList" %>

<%@ Import Namespace="Game.Facade" %>

<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="Btn" Src="~/Themes/Standard/Common_Btn.ascx" %>
<%@ Register TagPrefix="qp" TagName="Question" Src="~/Themes/Standard/Common_Question.ascx" %>
<%@ Register TagPrefix="qp" TagName="Service" Src="~/Themes/Standard/Common_Service.ascx" %>

<!DOCTYPE html >

<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />

    <link rel="stylesheet" type="text/css" href="/style/Bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/style/header.css" />
    <link rel="stylesheet" type="text/css" href="/style/styles.css" />
    <link href="../style/global_new.css" rel="stylesheet" />
    <link href="/style/news.css" rel="stylesheet" />
    <script src="/style/Bootstrap/js/jquery-3.1.1.min.js"></script>
</head>
<body>

    <qp:Header ID="sHeader" runat="server" />

    <div class="content">
        <div class="row">
            <div class="col-md-3 left">
                <div class="download">
                    <a href="/games/index.aspx">
                        <button class="btn btn-default btn-sm">
                            <h2>下载游戏大厅</h2>
                            <font><span class="glyphicon glyphicon-download"></span>立即下载</font>
                        </button>
                    </a>
                </div>
                <ul>
                    <li><a href="/Default.aspx">
                        <button class="btn btn-default"><span class="glyphicon glyphicon-usd"></span>充值中心</button></a></li>
                    <li><a href="#">
                        <button class="btn btn-default"><span class="glyphicon glyphicon-user"></span>新手帮助</button></a></li>
                    <li><a href="#">
                        <button class="btn btn-default"><span class="glyphicon glyphicon-user"></span>推广系统</button></a></li>
                    <li><a href="#">
                        <button class="btn btn-default"><span class="glyphicon glyphicon-question-sign"></span>问题反馈</button></a></li>
                </ul>
                <div class="service">
                    <div class="title">客服中心</div>
                    <div class="body">
                        <ul>
                            <li><span class="qqico"></span><a id="qq0" class="lh" href="http://wpa.qq.com/msgrd?V=1&Uin=516022666&Site=http://192.168.0.21:8063/&Menu=yes" target="blank">516022666</a></li>
                            <li><span class="qqico"></span><a id="qq1" class="lh" href="http://wpa.qq.com/msgrd?V=1&Uin=371037888&Site=http://192.168.0.21:8063/&Menu=yes" target="blank">371037888</a></li>
                        </ul>
                        <ul class="contact">
                            <li>
                                <h5><span class="glyphicon glyphicon-phone-alt"></span>客服电话</h5>
                                <h6 class="tel">0755-83547940</h6>
                            </li>
                            <li>
                                <h5><span class="glyphicon glyphicon-envelope"></span>客服电话</h5>
                                <h6 class="mail">SZWHcompany@163.com</h6>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-md-9 right">
                <div class="websitepath">
                    <ol class="breadcrumb">
                        <li><a href="/Default.aspx">首页</a></li>
                        <li class="active">新闻中心</li>
                    </ol>
                </div>
                <div class="news">
                    <!--新闻公告开始-->
                    <div class="news-title"><h5>新闻公告</h5></div>
                    <form id="form1" runat="server">
                        <div class="news-body">
                            <div class="news-list">
                                <ul>
                                    <asp:Repeater ID="rptNewsList" runat="server">
                                        <ItemTemplate>
                                            <li><span><%# Eval("IssueDate","{0:yyyy-MM-dd}")%></span><label></label>[<%# Convert.ToInt32(Eval("ClassID")) == 1 ? "新闻" : "公告"%>]&nbsp;<a href='NewsView.aspx?XID=<%# Eval("NewsID") %>' class="lh" target="_blank"><%# Eval("Subject")%></a></li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </div>
                            <div class="page">
                                <webdiyer:AspNetPager ID="anpPage" runat="server" AlwaysShow="true" FirstPageText="首页"
                                    LastPageText="末页" PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0"
                                    LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="共 %PageCount% 页"
                                    UrlPaging="false" OnPageChanging="anpPage_PageChanging" ShowCustomInfoSection="Never">
                                </webdiyer:AspNetPager>
                            </div>

                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <qp:Footer ID="sFooter" runat="server" />

    <script src="/js/levan.content.js"></script>
</body>
</html>
