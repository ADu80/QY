<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayCenter.aspx.cs" Inherits="Game.Web.PayCenter" %>

<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <link rel="stylesheet" type="text/css" href="style/layout.css" />
    <link rel="stylesheet" type="text/css" href="style/global.css" />
    <link rel="stylesheet" type="text/css" href="style/PayCenter.css" />
    <link href="style/header3.css" rel="stylesheet" />
    <style>
        body {
            width:100%;
            height:100%;
        }
        .footer {
            position: absolute;
            width: 100%;
            height: 12em;
            bottom: 0;
        }
    </style>
    <script src="js/jquery-1.10.2.min.js"></script>
    <script>
        $(function () {
            ; (function () {
                var wechatpay;
                $('.PayLeft div').click(function (e) {
                    $(this).addClass('Paycurrent').siblings().removeClass('Paycurrent');
                });
                $('.PayRight .PayBox').click(function (e) {
                    $(this).addClass('current').siblings().removeClass('current')
                });
                $('.PayRight .Paysub').click(function (e) {
                    if ($('.Apay_pay.Paycurrent').is('.Apay_pay.Paycurrent')) {
                        $('.Apay_Wrap').addClass('current');
                    } else (
                        $('.WeChat_Wrap').addClass('current')
                    )
                });
                $('.error').click(function () {
                    $(this).parent().parent().removeClass('current');
                })
            })();
        })

    </script>
</head>
<body>
    <qp:Header ID="sHeader" runat="server" />

    <!------------------      微信扫码分区       ------------------------->
    <div class="WeChat_Wrap">
        <div class="WeChat_in">
            <div class="WeChatLeft">
                <h3>微信支付</h3>
                <p class="Wechat_paymoney">支付金额：<span class="color">¥10</span></p>
                <p class="Wechat_pic">
                    <img src="img/wechatpay_erweima.jpg" width="183" alt="微信二维码"></p>
                <span class="alertcolor">请尽快处理订单</span>
            </div>
            <span class="error"></span>
        </div>
    </div>

    <!------------------      支付宝扫码分区       ------------------------->
    <div class="Apay_Wrap">
        <div class="Apay_in">
            <div class="ApayLeft">
                <h3>支付宝</h3>
                <p class="Apay_paymoney">支付金额：<span class="color">¥10</span></p>
                <p class="Apay_pic">
                    <img src="img/apay_erweima.jpg" width="183" alt="支付宝二维码"></p>
                <span class="alertcolor">请尽快处理订单</span>
            </div>
            <div class="ApayRight">
                <p>手机没在身边？</p>
                <input type="button" value="登录" class="btn" onclick="location = 'https://www.alipay.com/'">
            </div>
            <span class="error"></span>
        </div>
    </div>


    <div id="PayCenter">
        <div class="PayCenterBox">
            <div class="PayLeft">
                <div class="Apay_pay Paycurrent">
                    <span>支付宝扫码</span>
                </div>
                <div class="Wechat_pay">
                    <span>微信扫码</span>
                </div>
            </div>
            <div class="PayRight">
                <div class="PayBox_wrap">
                    <div class="PayBox current">
                        <img src="img/money.png" width="74" alt="元宝">
                        <p>
                            <span class="money">1元=10元宝</span>
                            <span class="integral">赠送50积分</span>
                        </p>
                    </div>
                    <div class="PayBox">
                        <img src="img/money.png" width="74" alt="元宝">
                        <p>
                            <span class="money">5元=50元宝</span>
                            <span class="integral">赠送50积分</span>
                        </p>
                    </div>
                    <div class="PayBox">
                        <img src="img/money.png" width="74" alt="元宝">
                        <p>
                            <span class="money">10元=100元宝</span>
                            <span class="integral">赠送50积分</span>
                        </p>
                    </div>
                    <div class="PayBox">
                        <img src="img/money.png" width="74" alt="元宝">
                        <p>
                            <span class="money">15元=150元宝</span>
                            <span class="integral">赠送50积分</span>
                        </p>
                    </div>
                    <div class="PayBox">
                        <img src="img/money.png" width="74" alt="元宝">
                        <p>
                            <span class="money">100元=1000元宝</span>
                            <span class="integral">赠送50积分</span>
                        </p>
                    </div>
                </div>

                <input type="submit" value="" class="Paysub">
            </div>
        </div>
    </div>
    <qp:Footer ID="sFooter" runat="server" />

</body>
</html>
