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
</head>
<body>
    <qp:Header ID="sHeader" runat="server" />
    <form id="form1" runat="server">
        <!--页面主体开始-->
        <div class="content container" style="margin-top: 8px;">
            <!--左边部分开始-->
            <div class="left col-md-3">
                <div class="leftbar">
                    <qp:GameSidebar ID="sGameSidebar" runat="server" />
                </div>
            </div>
            <!--左边部分结束-->
            <!--右边部分开始-->
            <div class="right col-md-9">
                <!--最新游戏开始-->
                <div class="groupbox lastest">
                    <div class="groupbox-title">
                        最新游戏
                    <img src="/images/new.gif" width="24" height="11" />
                    </div>
                    <div class="groupbox-body">
                        <ul>
                            <li><span>
                                <img src="/img/g1.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">掼蛋</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="/GameRules.aspx?KindID=3">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="/Download.aspx?KindID=3">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g2.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">广东麻将</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g3.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">拖拉机</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g4.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">斗地主</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="/Download.aspx?KindID=2">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g5.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">中国象棋</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g6.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">港式五张</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="/GameRules.aspx?KindID=1">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="/Download.aspx??KindID=1">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                        </ul>
                    </div>
                    <div class="recharge2">
                    </div>
                </div>
                <div class="groupbox hotest">
                    <div class="groupbox-title">
                        热门游戏
                    <img src="/images/hot.gif" width="17" height="8" />
                    </div>
                    <div class="groupbox-body">
                        <ul>
                            <li><span>
                                <img src="/img/g1.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">掼蛋</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g2.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">广东麻将</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g3.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">拖拉机</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g4.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">斗地主</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g5.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">中国象棋</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g6.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">港式五张</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g1.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">掼蛋</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g2.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">广东麻将</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g3.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">拖拉机</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g4.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">斗地主</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g5.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">中国象棋</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                            <li><span>
                                <img src="/img/g6.gif" /></span>
                                <div class="gameboxlabel">
                                    <a href="#" target="_blank" class="lh">港式五张</a><p>在翻山越岭及面临各种惊险中完成各种不同的任务、获取各类帮你跑的更远的道具，更能起劲的打各种不同的BOSS且面临惊心动魄的惊险。</p></div>
                                <label class="gamebox-detail">
                                    <a href="#" target="_blank">
                                        <img src="/images/js.gif" width="33" height="18" border="0" /></a> <a href="#">
                                            <img src="/images/down.gif" width="33" height="18" border="0" /></a></label>
                            </li>
                        </ul>
                    </div>
                    <div class="recharge2">
                    </div>
                </div>
            </div>
        </div>
        <!--页面主体结束-->
    </form>
    <qp:Footer ID="sFooter" runat="server" />
</body>
</html>
