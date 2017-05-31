<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Send.aspx.cs" Inherits="pay.poleneer.Send" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>支付</title>
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <link rel="icon" type="image/png" href="../../../..\theme\default\images\favicon.png">
    <link href="\css\amazeui.min.css" rel="stylesheet" type="text/css" />
    <link href="\css\style.css" rel="stylesheet" type="text/css" />
    <script src="\js\jquery-1.10.2.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Panel ID="Panel1" runat="server" Visible="false">
        <header data-am-widget="header" class="am-header am-header-default sq-head ">
			<div class="am-header-left am-header-nav">
				 
			</div>
			<h1 class="am-header-title">
  	            <a href="" class="">微信支付</a>
            </h1>
	    </header>
        <div style="height: 49px;"></div>
        <!--购物车空的状态-->
        <div class="login-logo">
            <asp:Image ID="Image1" runat="server" />
            <p>微信扫描支付</p>
        </div>




        <!--底部-->
        <div style="height: 55px;"></div>
        <div data-am-widget="navbar" class="am-navbar am-cf am-navbar-default sq-foot am-no-layout" id="">
        </div>


        </asp:Panel>
    </form>
</body>
</html>

