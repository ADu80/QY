<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewsView.aspx.cs" Inherits="Game.Web.News.NewsView" %>

<%@ Import Namespace="Game.Facade" %>

<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="/style/global_new.css" />
    <link rel="stylesheet" type="text/css" href="/style/Bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/style/header3.css" />
    <style>
        body {background: #dedede;}
        .content .left,.content .right{background:#fff;}
    </style>
</head>
<body>

    <qp:Header ID="sHeader" runat="server" />

    <!--新闻内容开始-->
    <div class="content container">
        <div class="left col-md-3">
        </div>
        <div class="right col-md-9">
            <div class="right-header">
                <ol class="breadcrumb">
                    <li><a href="/Default.aspx">首页</a></li>
                    <li><a href="#">新闻动态</a></li>
                    <%--<li class="active">充值中心</li>--%>
                </ol>
            </div>
            <div class="right-content">
                <div class="viewBody">
                    <div class="viewTitle f16 bold" style="border-bottom: dashed 1px #ccc;"><%= title %></div>
                    <div class="viewTitle hui6">类别：<%= type %> 来源：<%=source %> 发布于：<%= issueDate %></div>
                    <div class="ViewContent">
                        <%= content %>
什么是 Roon.io
Roon.io 是 Sam Soffes 和 Drew Wilson 两个人于 2003 年合作开发的一款类似 Ghost 的博客系统，也同样支持 Markdown 语法、界面也很漂亮，但是 Roon.io 是闭源产品，只能通过 roon.io 网站购买才能使用。
经过一年的运营，Roon.io 项目的两个创始人各有打算，即将分道扬镳。这才有了 John O'Nolan 收购 Roon.io 这件事。
Roon.io 将来的命运
Roon.io 号称有 10 万用户，合并之后都将迁移到 Ghost 系统，Roon.io 项目的部分代码将开源。
对 Ghost 有何影响
首先，Sam Soffes 将加入 Ghost 项目。重要的是 Roon.io 的 Markdown 编辑器很不错，以后将会合并到 Ghost 中，而且 Sam 还有一个 Mac OS 版的 Markdown 编辑器 － Whiskey ，估计将来也会成为 Ghost 专用编辑器。
什么是 Roon.io
Roon.io 是 Sam Soffes 和 Drew Wilson 两个人于 2003 年合作开发的一款类似 Ghost 的博客系统，也同样支持 Markdown 语法、界面也很漂亮，但是 Roon.io 是闭源产品，只能通过 roon.io 网站购买才能使用。
经过一年的运营，Roon.io 项目的两个创始人各有打算，即将分道扬镳。这才有了 John O'Nolan 收购 Roon.io 这件事。
Roon.io 将来的命运
Roon.io 号称有 10 万用户，合并之后都将迁移到 Ghost 系统，Roon.io 项目的部分代码将开源。
对 Ghost 有何影响
首先，Sam Soffes 将加入 Ghost 项目。重要的是 Roon.io 的 Markdown 编辑器很不错，以后将会合并到 Ghost 中，而且 Sam 还有一个 Mac OS 版的 Markdown 编辑器 － Whiskey ，估计将来也会成为 Ghost 专用编辑器。
什么是 Roon.io
Roon.io 是 Sam Soffes 和 Drew Wilson 两个人于 2003 年合作开发的一款类似 Ghost 的博客系统，也同样支持 Markdown 语法、界面也很漂亮，但是 Roon.io 是闭源产品，只能通过 roon.io 网站购买才能使用。
经过一年的运营，Roon.io 项目的两个创始人各有打算，即将分道扬镳。这才有了 John O'Nolan 收购 Roon.io 这件事。
Roon.io 将来的命运
Roon.io 号称有 10 万用户，合并之后都将迁移到 Ghost 系统，Roon.io 项目的部分代码将开源。
对 Ghost 有何影响
首先，Sam Soffes 将加入 Ghost 项目。重要的是 Roon.io 的 Markdown 编辑器很不错，以后将会合并到 Ghost 中，而且 Sam 还有一个 Mac OS 版的 Markdown 编辑器 － Whiskey ，估计将来也会成为 Ghost 专用编辑器。
什么是 Roon.io
Roon.io 是 Sam Soffes 和 Drew Wilson 两个人于 2003 年合作开发的一款类似 Ghost 的博客系统，也同样支持 Markdown 语法、界面也很漂亮，但是 Roon.io 是闭源产品，只能通过 roon.io 网站购买才能使用。
经过一年的运营，Roon.io 项目的两个创始人各有打算，即将分道扬镳。这才有了 John O'Nolan 收购 Roon.io 这件事。
Roon.io 将来的命运
Roon.io 号称有 10 万用户，合并之后都将迁移到 Ghost 系统，Roon.io 项目的部分代码将开源。
对 Ghost 有何影响
首先，Sam Soffes 将加入 Ghost 项目。重要的是 Roon.io 的 Markdown 编辑器很不错，以后将会合并到 Ghost 中，而且 Sam 还有一个 Mac OS 版的 Markdown 编辑器 － Whiskey ，估计将来也会成为 Ghost 专用编辑器。
什么是 Roon.io
Roon.io 是 Sam Soffes 和 Drew Wilson 两个人于 2003 年合作开发的一款类似 Ghost 的博客系统，也同样支持 Markdown 语法、界面也很漂亮，但是 Roon.io 是闭源产品，只能通过 roon.io 网站购买才能使用。
经过一年的运营，Roon.io 项目的两个创始人各有打算，即将分道扬镳。这才有了 John O'Nolan 收购 Roon.io 这件事。
Roon.io 将来的命运
Roon.io 号称有 10 万用户，合并之后都将迁移到 Ghost 系统，Roon.io 项目的部分代码将开源。
对 Ghost 有何影响
首先，Sam Soffes 将加入 Ghost 项目。重要的是 Roon.io 的 Markdown 编辑器很不错，以后将会合并到 Ghost 中，而且 Sam 还有一个 Mac OS 版的 Markdown 编辑器 － Whiskey ，估计将来也会成为 Ghost 专用编辑器。
什么是 Roon.io
Roon.io 是 Sam Soffes 和 Drew Wilson 两个人于 2003 年合作开发的一款类似 Ghost 的博客系统，也同样支持 Markdown 语法、界面也很漂亮，但是 Roon.io 是闭源产品，只能通过 roon.io 网站购买才能使用。
经过一年的运营，Roon.io 项目的两个创始人各有打算，即将分道扬镳。这才有了 John O'Nolan 收购 Roon.io 这件事。
Roon.io 将来的命运
Roon.io 号称有 10 万用户，合并之后都将迁移到 Ghost 系统，Roon.io 项目的部分代码将开源。
对 Ghost 有何影响
首先，Sam Soffes 将加入 Ghost 项目。重要的是 Roon.io 的 Markdown 编辑器很不错，以后将会合并到 Ghost 中，而且 Sam 还有一个 Mac OS 版的 Markdown 编辑器 － Whiskey ，估计将来也会成为 Ghost 专用编辑器。
                    </div>
                </div>
                <div class="page"><a id="next2" runat="server" title="">上一篇</a><a id="last2" runat="server" title="" href="">下一篇</a><a href="/News/NewsList.aspx" title="返回新闻列表">返回新闻列表</a></div>
            </div>
        </div>
        <!--新闻内容结束-->
    </div>
    <qp:Footer ID="sFooter" runat="server" />

</body>
</html>
