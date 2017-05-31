<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Common_Header2.ascx.cs" Inherits="Game.Web.Themes.Standard.Common_Header" %>
<%@ Import Namespace="Game.Facade" %>

<!--头部开始-->
<div class="header">
    <div class="container">
        <div class="login"><a href="#"><span></span>登录</a><a href="#"><span></span>注册</a></div>
        <div class="logo">
            <img src="/adv/p1.jpg" />
        </div>
        <div class="nav">
            <ul>
                <li class="nav-home"><span class="glyphicon glyphicon-home"></span><a href="/Default.aspx">首页</a></li>
                <li class="nav-news"><span class="glyphicon glyphicon-globe"></span><a href="/News/NewsList.aspx">新闻公告</a></li>
                <li class="nav-vip"><span class="glyphicon glyphicon-user"></span><a href="/Member/MIndex.aspx">会员中心</a></li>
                <li class="nav-pay"><span class="glyphicon glyphicon-usd"></span><a href="/Pay/PayIndex.aspx">充值中心</a></li>
                <li class="nav-tg"><span class="glyphicon glyphicon-user"></span><a href="/Spread/SpreadIndex.aspx">推广系统</a></li>
                <li class="nav-kf"><span class="glyphicon glyphicon-earphone"></span><a href="/Service/Index.aspx">客服中心</a></li>
                <li class="nav-shop"><span class="glyphicon glyphicon-shopping-cart"></span><a href="/Shop/ShopIndex.aspx">游戏商场</a></li>
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
                    <img src="/adv/p1.jpg" alt="First slide" />
                </div>
                <div class="item">
                    <img src="/adv/p2.jpg" alt="Second slide" />
                </div>
                <div class="item">
                    <img src="/adv/p3.jpg" alt="Third slide" />
                </div>
            </div>
        </div>
    </div>
</div>

<!--头部结束-->
