<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayIndex.aspx.cs" Inherits="Game.Web.Pay.PayIndex" %>

<%@ Import Namespace="Game.Facade" %>

<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="LeftBar" Src="~/Themes/Standard/Common_Left.ascx" %>


<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <link rel="stylesheet" type="text/css" href="/style/Bootstrap/css/bootstrap.min.css" />
    <link href="/style/pay_layout.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="/style/global_new.css" />
    <link rel="stylesheet" type="text/css" href="/style/header3.css" />
    <script src="/js/jquery-1.5.2.min.js" type="text/javascript"></script>
</head>
<body>

    <qp:Header ID="sHeader" runat="server" />

    <script type="text/javascript">
        $(document).ready(function () {
            $("#cbType").attr("checked", "");
        });
    </script>

    <div class="content">
        <div class="row">
            <div class="col-md-3 left">
                <qp:LeftBar ID="LeftBar1" runat="server" />
            </div>
            <div class="col-md-9 right">
                <div class="right-header">
                    <ol class="breadcrumb">
                        <li><a href="/Default.aspx">首页</a></li>
                        <li class="active">充值中心</li>
                    </ol>
                </div>
                <div class="right-content">
                    <div class="groupbox">
                        <div class="group-title">
                            <h3>推荐充值方式</h3>
                        </div>
                        <div class="group-body">
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayOnLine.aspx" class="card1"></a></span>
                                <label>网银大额充值，安全、快捷的在线充值服务，即充即可到帐，1分钟完成！</label>
                                <a href="/Pay/PayOnLine.aspx" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayCardFill.aspx" class="card2"></a></span>
                                <label>本站发行的充值卡，安全、快捷，购买后便可充值！</label>
                                <a href="/Pay/PayCardFill.aspx" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayYB.aspx" class="card12"></a></span>
                                <label>网银大额充值，安全、快捷的在线充值服务，即充即可到帐，1分钟完成</label>
                                <a href="/Pay/PayYB.aspx" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayMobile.aspx?type=1" class="card6"></a></span>
                                <label>支持全国通用的神州行手机充值卡（卡号17位，密码18位）。</label>
                                <a href="/Pay/PayMobile.aspx?type=1" class="btnRecharge">立即购买</a>
                            </div>
                        </div>
                    </div>
                    <div class="groupbox">
                        <div class="group-title">
                            <h3>其他充值方式</h3>
                        </div>
                        <div class="group-body">
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayMobile.aspx?type=2" class="card5"></a></span>
                                <label>支持全国通用的联通手机充值卡（卡号15位，密码19位）。</label>
                                <a href="/Pay/PayMobile.aspx?type=2" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayMobile.aspx?type=3" class="card7"></a></span>
                                <label>支持全国通用的电信手机充值卡（卡号19位，密码18位）。</label>
                                <a href="/Pay/PayMobile.aspx?type=3" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayVB.aspx" class="card4"></a></span>
                                <label>全国电话用户（含部分手机）通过当地电信业务获取V币，再凭V币到网站充值。</label>
                                <a href="/Pay/PayVB.aspx" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayGame.aspx?type=1" class="card8"></a></span>
                                <label>支持全国通用的盛大一卡通 （卡号 15 位，密码 8 位）。 </label>
                                <a href="/Pay/PayGame.aspx?type=1" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayGame.aspx?type=3" class="card3"></a></span>
                                <label>支持全国通用的网易一卡通 （卡号 13 位，密码 9 位）。 </label>
                                <a href="/Pay/PayGame.aspx?type=3" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayGame.aspx?type=2" class="card9"></a></span>
                                <label>支持全国通用的征途游戏卡 （卡号 16 位，密码 8 位）。 </label>
                                <a href="/Pay/PayGame.aspx?type=2" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayGame.aspx?type=4" class="card10"></a></span>
                                <label>支持全国通用的搜狐一卡通 （卡号 20 位，密码 12 位）。</label>
                                <a href="/Pay/PayGame.aspx?type=4" class="btnRecharge">立即购买</a>
                            </div>
                            <div class="cardbox clearfix">
                                <span><a href="/Pay/PayGame.aspx?type=5" class="card11"></a></span>
                                <label>支持全国通用的完美一卡通 （卡号 10 位，密码 15 位）。</label>
                                <a href="/Pay/PayGame.aspx?type=5" class="btnRecharge">立即购买</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <qp:Footer ID="sFooter" runat="server" />
    <script>
        $('.header .nav ul li.nav-pay').addClass('active');
    </script>
</body>
</html>
