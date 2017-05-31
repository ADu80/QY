<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Common_Left.ascx.cs" Inherits="Game.Web.Themes.Common_Left" %>
<div class="download">
    <a href="/games/index.aspx">
        <button class="btn btn-default btn-sm">
            <h2>下载游戏大厅</h2>
            <font><span class="glyphicon glyphicon-download"></span>立即下载</font>
        </button>
    </a>
</div>
<ul>
    <li><a href="/Pay/PayIndex.aspx">
        <button class="btn btn-default"><span class="glyphicon glyphicon-usd"></span>充值中心</button></a></li>
<%--    <li><a href="/Service/Index.aspx">
        <button class="btn btn-default"><span class="glyphicon glyphicon-user"></span>新手帮助</button></a></li>
    <li><a href="/Spread/SpreadIndex.aspx">
        <button class="btn btn-default"><span class="glyphicon glyphicon-user"></span>推广系统</button></a></li>
    <li><a href="/Service/FeedbackList.aspx">
        <button class="btn btn-default"><span class="glyphicon glyphicon-question-sign"></span>问题反馈</button></a></li>--%>
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
                <h6 class="tel">020-37759241</h6>
            </li>
            <li>
                <h5><span class="glyphicon glyphicon-envelope"></span>客服邮箱</h5>
                <h6 class="mail">gzqykj@163.com</h6>
            </li>
        </ul>
    </div>
</div>
