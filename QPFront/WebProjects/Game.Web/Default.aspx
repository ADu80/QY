<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Game.Web.Default" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
    <link rel="stylesheet" type="text/css" href="style/Bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="style/default.css" />

    <script src="//cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>

    <%--<script src="/style/Bootstrap/js/jquery-3.1.1.min.js"></script>--%>
    <script src="js/jquery-1.10.2.min.js"></script>
    <script src="/style/Bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="header">
        <div class="container">
            <%--<div class="login"><a href="#"><span></span>登录</a><a href="#"><span></span>注册</a></div>--%>
            <div class="logo">
                <h1>棋游网络</h1>
                <%--<img src="adv/p1.jpg" />--%>
            </div>
            <div class="nav">
                <ul>
                    <li class="nav-home"><span class="glyphicon glyphicon-home"></span><a href="/Default.aspx">首页</a></li>
                    <%--<li class="nav-news"><span class="glyphicon glyphicon-globe"></span><a href="/News/NewsList.aspx">新闻公告</a></li>--%>
                    <li class="nav-vip"><span class="glyphicon glyphicon-user"></span><a href="/Member/MIndex.aspx">会员中心</a></li>
                    <%--<li class="nav-pay"><span class="glyphicon glyphicon-usd"></span><a href="/Pay/PayIndex.aspx">充值中心</a></li>--%>
                    <%--<li><span class="glyphicon glyphicon-user"></span><a href="/Match/Index.aspx">比赛中心</a></li>--%>
                    <li class="nav-tg"><span class="glyphicon glyphicon-user"></span><a href="/Spread/SpreadIndex.aspx">推广系统</a></li>
                    <li class="nav-kf"><span class="glyphicon glyphicon-earphone"></span><a href="/Service/Customer.aspx">客服中心</a></li>
<%--                    <li class="nav-cz"><span class="glyphicon glyphicon-usd"></span><a href="/Pay/PayCenter.aspx">充值中心</a></li>--%>
                    <%--<li class="nav-shop"><span class="glyphicon glyphicon-shopping-cart"></span><a href="/Shop/ShopIndex.aspx">游戏商场</a></li>--%>
                </ul>
            </div>
            <div id="myCarousel" class="carousel slide">
                <!-- 轮播（Carousel）指标 -->
                <ol class="carousel-indicators">
                    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                    <li data-target="#myCarousel" data-slide-to="1"></li>
                    <li data-target="#myCarousel" data-slide-to="2"></li>
                </ol>
                <!-- 轮播（Carousel）项目 -->
                <div class="carousel-inner">
                    <div class="item active">
                        <img src="adv/p1.jpg" alt="First slide" />
                    </div>
                    <div class="item">
                        <img src="adv/p2.jpg" alt="Second slide" />
                    </div>
                    <div class="item">
                        <img src="adv/p3.jpg" alt="Third slide" />
                    </div>
                </div>
            </div>
            <div class="download">
                <%--<h2>棋游游戏大厅</h2>
                <h5>做最好的棋牌游戏、最有风格的平台、棋游让你乐翻天</h5>
                <button type="button" class="btn btn-default btn-lg">
                    <span class="glyphicon glyphicon-download-alt"></span>下载游戏大厅
                </button>
                <div class="download-mobile">
                    <a href="#">
                        <img src="img2/android.png" title="苹果手机" />
                        <h4>苹果手机</h4>
                    </a>
                    <a href="#">
                        <img src="img2/android.png" title="苹果手机" />
                        <h4>安卓手机</h4>
                    </a>
                    <a href="#" class="last">
                        <img src="img2/android.png" title="苹果手机" />
                        <h4>iPad</h4>
                    </a>
                </div>--%>
            </div>
        </div>
    </div>
    <div class="content">
        <div class="panel-container">
            <div class="panel container">
                <div class="panel-left">
                    <div class="panel-heading">
                        <h3>热门游戏</h3>
                        <a href="/Games/Index.aspx">
                            <h4>更多>></h4>
                        </a>
                    </div>
                    <div class="panel-body">
                        <ul>
                            <li><span><a href="/Games/Index.aspx">
                                <img src="img/h1.gif" border="0" class="img" /></a><br />
                                <a href="/Games/Index.aspx" class="lh">掼蛋</a></span></li>
                            <li><span><a href="/Games/Index.aspx">
                                <img src="img/h2.gif" border="0" class="img" /></a><br />
                                <a href="/Games/Index.aspx" class="lh">斗地主</a></span></li>
                            <li><span><a href="/Games/Index.aspx">
                                <img src="img/h3.gif" border="0" class="img" /></a><br />
                                <a href="/Games/Index.aspx" class="lh">港式五张</a></span></li>
                            <li><span><a href="/Games/Index.aspx">
                                <img src="img/h4.gif" border="0" class="img" /></a><br />
                                <a href="/Games/Index.aspx" class="lh">中国象棋</a></span></li>
                            <li><span><a href="/Games/Index.aspx">
                                <img src="img/h4.gif" border="0" class="img" /></a><br />
                                <a href="/Games/Index.aspx" class="lh">炸金花</a></span></li>
                        </ul>
                    </div>
                </div>
                <div class="panel-right">
                    <h4>热点新闻</h4>
                    <ul class="rankinglist">
                        <asp:Repeater ID="rptNews" runat="server">
                            <ItemTemplate>
                                <li class="news-item"><span class="arrow"></span><span class="hui6"><%# Eval("IssueDate","{0:yyyy-MM-dd}")%></span>[<%# GetNewsType(Eval("ClassID")) %>]&nbsp;<a href='/News/NewsView.aspx?XID=<%# Eval("NewsID") %>' class="lh" target="_blank"><%# Eval("Subject")%></a></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>
            </div>
        </div>
<%--        <div class="panel-container">
            <div class="panel container">
                <div class="panel-left">
                    <div class="panel-heading">
                        <h3>游戏商城</h3>
                        <a href="/Shop/ShopIndex.aspx">
                            <h4>更多>></h4>
                        </a>
                    </div>
                    <div class="panel-body">
                        <ul>
                            <li><span>
                                <img src="img/cd.gif" class="img" /></span><br />
                                <span><a href="/Shop/ShopIndex.aspx" class="lh">臭蛋</a></span><br />
                                <span class="cheng">1000金币</span><br />
                                <span><a href="/Shop/ShopIndex.aspx">
                                    <img src="images/viewInfo.gif" border="0" /></a>
                                </span>
                            </li>
                            <li><span>
                                <img src="img/xy.gif" class="img" /></span><br />
                                <span><a href="/Shop/ShopIndex.aspx" class="lh">香烟</a></span><br />
                                <span class="cheng">1000金币</span><br />
                                <span><a href="/Shop/ShopIndex.aspx">
                                    <img src="images/viewInfo.gif" border="0" /></a>
                                </span>
                            </li>
                            <li><span>
                                <img src="img/qc.gif" class="img" /></span><br />
                                <span><a href="/Shop/ShopIndex.aspx" class="lh">汽车</a></span><br />
                                <span class="cheng">1000金币</span><br />
                                <span><a href="/Shop/ShopIndex.aspx">
                                    <img src="images/viewInfo.gif" border="0" /></a>
                                </span>
                            </li>
                            <li><span>
                                <img src="img/zd.gif" class="img" /></span><br />
                                <span><a href="/Shop/ShopIndex.aspx" class="lh">炸弹</a></span><br />
                                <span class="cheng">1000金币</span><br />
                                <span><a href="/Shop/ShopIndex.aspx">
                                    <img src="images/viewInfo.gif" border="0" /></a>
                                </span>
                            </li>
                            <li><span>
                                <img src="img/pj.gif" class="img" /></span><br />
                                <span><a href="/Shop/ShopIndex.aspx" class="lh">啤酒</a></span><br />
                                <span class="cheng">1000金币</span><br />
                                <span><a href="/Shop/ShopIndex.aspx">
                                    <img src="images/viewInfo.gif" border="0" /></a>
                                </span>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="panel-right">
                    <h4>财富排行</h4>
                    <ul class="rankinglist">
                        <asp:Repeater runat="server" ID="rptScoreRanking">
                            <ItemTemplate>
                                <li title="<%# Eval("NickName") %>">
                                    <span class="orderno"><%# Container.ItemIndex+1 %></span>
                                    <span class="nickname"><%# Eval("NickName") %></span>
                                    <span class="val"><%# Eval("Score") %></span>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>
            </div>
        </div>--%>
        <div class="panel-container">
            <div class="panel container">
                <div class="panel-left">
                    <div class="panel-heading">
                        <h3>玩家靓照</h3>
                    </div>
                    <div class="panel-body">
                        <ul class="gamer-pic">
                            <li>
                                <img src="img/p1.gif" class="img" /></li>
                            <li>
                                <img src="img/p2.gif" class="img" /></li>
                            <li>
                                <img src="img/p3.gif" class="img" /></li>
                            <li>
                                <img src="img/p4.gif" class="img" /></li>
                            <li>
                                <img src="img/p3.gif" class="img" /></li>
                        </ul>
                    </div>
                </div>
                <div class="panel-right">
                    <h4>常见问题</h4>
                    <ul class="rankinglist">
                        <asp:Repeater ID="rptIssueList" runat="server">
                            <ItemTemplate>
                                <li><span class="arrow"></span><a href="/Service/IssueView.aspx?XID=<%# Eval("IssueID") %>" target="_blank" class="lh"><%# Eval("IssueTitle")%></a></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="footer">
        <div class="copyrightBg">
            <div class="main">
                <ul>
                    <li><span class="footer-nav">
                        <a href="/Service/Customer.aspx" target="_blank" class="lh">新手帮助</a> | 
<%--			            <a href="/Pay/PayIndex.aspx" class="lh">充值中心</a> | --%>
			            <a href="/Introduce/Company.aspx" target="_blank" class="lh">关于我们</a> | 
			            <%--<a href="/SiteMap.aspx" target="_blank" class="lh">网站地图</a></span>--%>
                    </li>
                    <li><span>抵制不良游戏 拒绝盗版游戏 注意自我保护 慎防上当受骗 适度游戏益脑 沉迷游戏伤身 合理安排时间 享受健康生活</span></li>
                    <li><span>版权所有：广州棋游网络有限公司 版权证书 软件产品登记证书 ICP许可证：粤ICP备16097719号 <a href="http://www.miitbeian.gov.cn" target="_blank" class="lh">[粤ICP备16097719号]</a></span></li>
                    <li><span>快乐何处寻，棋游乐翻天！ E-MAIL：gzqykj@163.com</span></li>
                    <li><span>
                        <img src="/images/copyright.gif" /></span></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
    </div>

    <script>
        $("#myCarousel").carousel('cycle');
        $("#gamerPic").carousel('cycle');
        $('.header .nav ul li.nav-home').addClass('active');
    </script>

</body>
</html>
