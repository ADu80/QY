<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Company.aspx.cs" Inherits="Game.Web.Introduce.Company" %>

<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>广州棋游-关于我们</title>
    <link href="/style/Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/style/company.css" rel="stylesheet" />
    <script src="/style/Bootstrap/js/jquery-3.1.1.min.js"></script>
    <script src="/style/Bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-inverse" role="navigation">
        <div><a href="/Default.aspx" class="backwww"><span>返回游戏官网</span></a></div>
        <div class="container-fluid container">
            <div class="navbar-header">
                <a class="navbar-brand" href="#">关于我们</a>
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
    <div class="content">
        <div class="introduce">
            <article class="container">
                <h3>公司简介</h3>
                <p>
                    瓜迪奥拉希望执教阿根廷，想必和梅西的存在不无关系，而且阿根廷众星云集，有大批技术型选手，符合瓜迪奥拉执教的理念。另外，阿根廷作为世界足坛的顶尖豪强之一，已经有近30年未曾染指大赛冠军（上次夺冠是1993年美洲杯），而如能带队拿下阔别30年的世界杯（阿根廷上次夺冠是1986年），更将是一个极大的成就。
　　不过，即便瓜迪奥拉有意执教阿根廷，时机依然是最大的阻碍，他如今在曼城干得风生水起，近期内恐怕不会另作他谋，而2018年俄罗斯世界杯已经迫近，能否赶得上是个大问题，除非阿根廷足协和曼城达成一致，能让瓜帅兼顾带队（例如希丁克在埃因霍温时曾兼职带澳大利亚打进06世界杯淘汰赛），否则梅西冲击世界杯的最后黄金期（2018年梅西31岁），瓜迪奥拉恐怕就会错过了。
　　另外，阿圭罗还谈到了瓜迪奥拉平日带队的一些情况。“我不知道他抓到了谁在玩手机，结果他下令把网络全断了。”
　　“他平时和球员们说英语，只和新来的诺利托说西班牙语，有时候他会混杂一些德语，他德语也说的很好。”
                </p>
                <p>
                    <a>更多...</a>
                </p>
            </article>
        </div>
        <div class="culture">
            <article class="container">
                <h3>活动风采</h3>
                <a href="#">
                    <img class="events-pic" src="/adv/p1.jpg" alt="First slide" /></a>
                <a href="#">
                    <img class="events-pic" src="/adv/p2.jpg" alt="Second slide" /></a>
                <a href="#">
                    <img class="events-pic" src="/adv/p3.jpg" alt="Third slide" /></a>
                <a href="#">
                    <img class="events-pic" src="/adv/p2.jpg" alt="Second slide" /></a>
                <a href="#">
                    <img class="events-pic" src="/adv/p3.jpg" alt="Third slide" /></a>
            </article>

            <%--<div class="container">
                <h3>活动风采</h3>
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
                            <a href="#">
                                <img src="/adv/p1.jpg" alt="First slide" /></a>
                        </div>
                        <div class="item">
                            <a href="#">
                                <img src="/adv/p2.jpg" alt="Second slide" /></a>
                        </div>
                        <div class="item">
                            <a href="#">
                                <img src="/adv/p3.jpg" alt="Third slide" /></a>
                        </div>
                    </div>
                </div>
            </div>--%>
        </div>
        <div class="contact">
            <div class="container">
                <h3>联系我们</h3>

                <p>联系电话：040-80008000<small>（服务时间从早上9点到凌晨2点）</small></p>
                <p>在线客服：<a>进入</a><small>（服务时间从早上9点到凌晨2点）</small></p>
                <p>客服QQ：445458556 | 445455232</p>

            </div>
        </div>
        <div class="recruit">
            <div class="container">
                <h3>招聘信息</h3>
                <p><a>智联招聘</a>  |  <a href="/Introduce/recruit.aspx">官网</a></p>
                <p>也可简历投递到邮箱：qy@qy.com</p>
            </div>
        </div>
    </div>

    <qp:Footer ID="sFooter" runat="server" />

    <script>
        $('#myCarousel').carousel('cycle');
    </script>
</body>
</html>
