<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShopIndex.aspx.cs" Inherits="Game.Web.Shop.ShopIndex" %>

<%@ Import Namespace="Game.Facade" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header2.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="Btn" Src="~/Themes/Standard/Common_Btn.ascx" %>
<%@ Register TagPrefix="qp" TagName="Question" Src="~/Themes/Standard/Common_Question.ascx" %>
<%@ Register TagPrefix="qp" TagName="Service" Src="~/Themes/Standard/Common_Service.ascx" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%--<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />--%>
    <link rel="stylesheet" type="text/css" href="/style/Bootstrap/css/bootstrap.min.css" />
    <%--<link rel="stylesheet" type="text/css" href="/style/global_new.css" />--%>
    <link rel="stylesheet" type="text/css" href="/style/header2.css" />
    <link rel="stylesheet" type="text/css" href="/style/shop.css" />
    <%--<script src="/style/Bootstrap/js/jquery-3.1.1.min.js"></script>--%>
    <script src="../js/jquery-1.10.2.min.js"></script>
    <script src="/style/Bootstrap/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function () {
            $("#myCarousel").carousel('cycle');
        });
    </script>

</head>
<body>
    <qp:Header ID="sHeader" runat="server" />
    <!--页面主体开始-->
    <div class="content">
        <div class="container banner banner-all">
            <h3 class=""><font>商品列表</font>
            </h3>
            <a class="a-more" href="#">
                <h5>更多>></h5>
            </a>
            <ul class="shoppinglist">
                <li>
                    <img class="goods-pic" src="/img/prop_01.gif" /><br />
                    <label><a href="#" class="lh">双倍积分卡</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_02.gif" /><br />
                    <label><a href="#" class="lh">四倍积分卡</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_03.gif" /><br />
                    <label><a href="#" class="lh">负分清零</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_04.gif" /><br />
                    <label><a href="#" class="lh">清逃跑率</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_01.gif" /><br />
                    <label><a href="#" class="lh">双倍积分卡</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_02.gif" /><br />
                    <label><a href="#" class="lh">四倍积分卡</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_03.gif" /><br />
                    <label><a href="#" class="lh">负分清零</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_04.gif" /><br />
                    <label><a href="#" class="lh">清逃跑率</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
            </ul>
        </div>
        <!--道具商城开始-->
        <div class="container banner banner-games">
            <h3 class=""><font><span class="glyphicon glyphicon-shopping-cart"></span>道具商城</font>
            </h3>
            <a class="a-more" href="#">
                <h5>更多>></h5>
            </a>
            <ul class="shoppinglist">
                <li>
                    <img class="goods-pic" src="/img/prop_01.gif" /><br />
                    <label><a href="#" class="lh">双倍积分卡</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_02.gif" /><br />
                    <label><a href="#" class="lh">四倍积分卡</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_03.gif" /><br />
                    <label><a href="#" class="lh">负分清零</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/prop_04.gif" /><br />
                    <label><a href="#" class="lh">清逃跑率</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>
                        <img src="/images/buy.gif" />
                        <img src="/images/present.gif" width="33" height="18" />
                    </label>
                </li>
            </ul>
        </div>
        <!--道具商城结束-->
        <!--礼物商城开始-->
        <div class="container banner banner-gift">
            <h3 class=""><font><span class="glyphicon glyphicon-shopping-cart"></span>礼物商城</font>
            </h3>
            <a class="a-more" href="#">
                <h5>更多>></h5>
            </a>
            <ul class="shoppinglist">
                <li>
                    <img class="goods-pic" src="/img/xw.gif" /><br />
                    <label><a href="#" class="lh">香吻</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>魅力点：+1</label><label>魅力值：+1</label><br />
                    <label>
                        <img src="/images/viewInfo.gif" border="0" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/xh.gif" /><br />
                    <label><a href="#" class="lh">鲜花</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>魅力点：+1</label><label>魅力值：+1</label><br />
                    <label>
                        <img src="/images/viewInfo.gif" border="0" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/qc.gif" /><br />
                    <label><a href="#" class="lh">汽车</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>魅力点：+1</label><label>魅力值：+1</label><br />
                    <label>
                        <img src="/images/viewInfo.gif" border="0" />
                    </label>
                </li>
                <li>
                    <img class="goods-pic" src="/img/gz.gif" /><br />
                    <label><a href="#" class="lh">鼓掌</a></label><br />
                    <label class="Fline">原价格：1000</label><br />
                    <label class="cheng">会员价：900</label><br />
                    <label>魅力点：+1</label><label>魅力值：+1</label><br />
                    <label>
                        <img src="/images/viewInfo.gif" border="0" />
                    </label>
                </li>
                <%--                <li><span>
                    <img src="/img/pj.gif" width="90" height="90" /></span>
                    <label>
                        <a href="#" class="lh">啤酒</a></label>
                    <label class="Fline">
                        原价格：1000</label><label class="cheng">会员价：900</label><label>魅力点：+1</label><label>魅力值：+1</label><label><img
                            src="/images/viewInfo.gif" border="0" /></label>
                </li>
                <li><span>
                    <img src="/img/xy.gif" /></span>
                    <label>
                        <a href="#" class="lh">香烟</a></label>
                    <label class="Fline">
                        原价格：1000</label><label class="cheng">会员价：900</label><label>魅力点：+1</label><label>魅力值：+1</label><label><img
                            src="/images/viewInfo.gif" border="0" /></label>
                </li>
                <li><span>
                    <img src="/img/zj.gif" /></span>
                    <label>
                        <a href="#" class="lh">钻戒</a></label><label class="Fline">原价格：1000</label><label
                            class="cheng">会员价：900</label><label>魅力点：+1</label>
                    <label>
                        魅力值：+1</label><label><img src="/images/viewInfo.gif" border="0" /></label>
                </li>
                <li><span>
                    <img src="/img/bs.gif" /></span><label><a href="#" class="lh">别墅</a></label><label
                        class="Fline">原价格：1000</label><label class="cheng">会员价：900</label><label>魅力点：+1</label><label>魅力值：+1</label><label><img
                            src="/images/viewInfo.gif" border="0" /></label>
                </li>
                <li><span>
                    <img src="/img/cd.gif" /></span><label><a href="#" class="lh">臭蛋</a></label><label
                        class="Fline">原价格：1000</label><label class="cheng">会员价：900</label>
                    <label>
                        魅力点：-1</label>
                    <label>
                        魅力值：+1</label><label><img src="/images/viewInfo.gif" border="0" /></label>
                </li>
                <li><span>
                    <img src="/img/zt.gif" /></span><label><a href="#" class="lh">砖头</a></label><label
                        class="Fline">原价格：1000</label><label class="cheng">会员价：900</label>
                    <label>
                        魅力点：-1</label>
                    <label>
                        魅力值：+1</label><label><img src="/images/viewInfo.gif" border="0" /></label>
                </li>
                <li><span>
                    <img src="/img/zd.gif" width="90" height="90" /></span>
                    <label>
                        <a href="#" class="lh">炸弹</a></label>
                    <label class="Fline">
                        原价格：1000</label><label class="cheng">会员价：900</label>
                    <label>
                        魅力点：-1</label>
                    <label>
                        魅力值：+1</label><label><img src="/images/viewInfo.gif" border="0" /></label>
                </li>--%>
            </ul>
        </div>
    </div>
    <!--页面主体结束-->
    <qp:Footer ID="sFooter" runat="server" />

    <script>
        $('.header .nav ul li.nav-shop').addClass('active');
    </script>
</body>
</html>
