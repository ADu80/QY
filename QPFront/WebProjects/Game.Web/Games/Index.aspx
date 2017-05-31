<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Games.Index" %>

<%@ Import Namespace="Game.Facade" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="GameSidebar" Src="~/Themes/Standard/Game_Sidebar.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="/style/global_new.css" />
    <link rel="stylesheet" type="text/css" href="/style/Bootstrap/css/bootstrap.min.css" />
    <link href="/style/Iconfont/iconfont.css" rel="stylesheet" />
    <link href="/style/game_new.css" rel="stylesheet" />
    <script src="/js/jquery-1.10.2.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.gametype li').click(function () {
                $('.gametype li').removeClass('active');
                $(this).addClass('active');
                if ($(this).text() == "扑克") {
                    $('.game-pk').css({ display: 'block' });
                    $('.game-mj').css({ display: 'none' });
                }
                else {
                    $('.game-pk').css({ display: 'none' });
                    $('.game-mj').css({ display: 'block' });
                }
            });
        });
    </script>
</head>
<body>
    <qp:Header ID="sHeader" runat="server" />
    <!--页面主体开始-->
    <div class="content container" style="margin-top: 8px;">
        <!--左边部分开始-->
        <div class="left col-md-3">
            <ul class="gametype">
                <li>扑克</li>
                <li>麻将</li>
            </ul>
        </div>
        <!--左边部分结束-->
        <!--右边部分开始-->
        <div class="right col-md-9">
            <div class="gamebox game-pk">
                <div class="gamedes">
                    <img src="/Games/hlddz.png" />
                    <div class="game-intro">
                        <h2><a href="#" target="_blank" class="lh">欢乐斗地主</a></h2>
                        <p>斗地主"是一款最初流行于湖北三人扑克游戏，两个农民联合对抗一名地主，由于其规则简单、娱乐性强，迅速风靡全国。"欢乐斗地主"是在传统规则的基础上，引入"欢乐豆"积分，并且增加抢地主、明牌、癞子等一系列新玩法，而推出的一款更紧张刺激、更富于变化的"斗地主"游戏。</p>
                    </div>
                </div>
                <%--<div class="gamebox-detail">
                    <a href="#" target="_blank">
                        <img src="/images/js.gif" width="33" height="18" border="0" />
                    </a>
                    <a href="/Download.aspx?KindID=2">
                        <img src="/images/down.gif" width="33" height="18" border="0" />
                    </a>
                </div>--%>
            </div>
            <div class="gamebox game-pk">
                <div class="gamedes">
                    <img src="/Games/dzpk.jpg" />
                    <div class="game-intro">
                        <h2><a href="#" target="_blank" class="lh">德州扑克</a></h2>
                        <p>德克萨斯扑克于20世纪初开始于德克萨斯洛布斯镇，是一款定位在锻炼智力水平、勇气的纯休闲类游戏。德克萨斯扑克是一种技巧性非常强、运气成分相对较少的扑克游戏，易于上手但难于精通，游戏过程中需要充分的和其他玩家斗智力、耍手腕、动脑筋，只有知己知彼方能百战百胜。</p>
                    </div>
                </div>
                <%--<div class="gamebox-detail">
                    <a href="#" target="_blank">
                        <img src="/images/js.gif" width="33" height="18" border="0" />
                    </a>
                    <a href="/Download.aspx?KindID=2">
                        <img src="/images/down.gif" width="33" height="18" border="0" />
                    </a>
                </div>--%>
            </div>
            <div class="gamebox game-mj">
                <div class="gamedes">
                    <img src="/Games/gbmj.jpg" />
                    <div class="game-intro">
                        <h2><a href="#" target="_blank" class="lh">国标麻将</a></h2>
                        <p>国标麻将，是麻将的一种玩法，其规则为中国国家体育总局于1998年7月所制定。其后在众多国际及国内麻将竞赛中应用，故被称为国标麻将。国标摒弃了大众麻将的赌博性质，同时又将番种增加至81种，极大的增加了趣味性与竞技性。国标麻将8番起胡，增加了比赛的难度，同时也增加了趣味性。国标正在逐渐被大众所接受，成为一种时尚的娱乐方式。</p>
                    </div>
                </div>
                <%--<div class="gamebox-detail">
                    <a href="#" target="_blank">
                        <img src="/images/js.gif" width="33" height="18" border="0" />
                    </a>
                    <a href="#">
                        <img src="/images/down.gif" width="33" height="18" border="0" />
                    </a>
                </div>--%>
            </div>
        </div>
    </div>
    <!--页面主体结束-->
    <qp:Footer ID="sFooter" runat="server" />
</body>
</html>
