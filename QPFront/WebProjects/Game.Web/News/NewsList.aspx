<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewsList.aspx.cs" Inherits="Game.Web.News.NewsList" %>

<%@ Import Namespace="Game.Facade" %>

<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="LeftBar" Src="~/Themes/Standard/Common_Left.ascx" %>

<!DOCTYPE html >

<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%--    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />--%>

    <link rel="stylesheet" type="text/css" href="/style/Bootstrap/css/bootstrap.min.css" />
    <link href="/style/global_new.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="/style/header3.css" />
    <%--<script src="/style/Bootstrap/js/jquery-3.1.1.min.js"></script>--%>
    <script src="../js/jquery-1.10.2.min.js"></script>
</head>
<body>

    <qp:Header ID="sHeader" runat="server" />

    <div class="content">
        <div class="row">
            <div class="col-md-3 left">
                <qp:LeftBar ID="LeftBar1" runat="server" />
            </div>
            <div class="col-md-9 right">
                <div class="right-header">
                    <ol class="breadcrumb">
                        <li><a href="/Default.aspx">首页</a></li>
                        <li class="active">新闻中心</li>
                    </ol>
                </div>
                <div class="right-content">
                    <!--新闻公告开始-->
                    <div class="news-title">
                        <h5>新闻公告</h5>
                    </div>
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
                                    LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="共 %PageCount% 页" CssClass=".pager"
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

    <script src="/js/levan.news.js"></script>
    <script>
        $('.header .nav ul li.nav-news').addClass('active');
    </script>
</body>
</html>
