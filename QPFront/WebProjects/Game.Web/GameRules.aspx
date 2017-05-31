<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameRules.aspx.cs" Inherits="Game.Web.Games.GameRules" %>

<%@ Import Namespace="Game.Facade" %>
<%@ Import Namespace="Game.Utils" %>
<%@ Import Namespace="Game.Entity.NativeWeb" %>
<%@ Import Namespace=" Game.Entity.Platform" %>

<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="GameSidebar" Src="~/Themes/Standard/Game_Sidebar.ascx" %>

<script type="text/C#" runat="server">

    //定义变量
    protected NativeWebFacade webFacade = new NativeWebFacade();
    protected int kindID = 0;
    protected string image = string.Empty;
    protected string intraduction = string.Empty;
    protected string rule = string.Empty;
    protected string score = string.Empty;
    protected string title = string.Empty;

    //页面载入
    protected void Page_Load(object sender, EventArgs e)
    {
        kindID = GameRequest.GetQueryInt("KindID", 0);
        if (kindID == 0)
        {
            kindID = GameRequest.GetQueryInt("GameID", 0);
        }

        //有自定义规则则跳转
        if (kindID != 0)
        {
            PlatformFacade platformFacade = new PlatformFacade();
            StringBuilder sqlQuery = new StringBuilder();
            sqlQuery.AppendFormat("SELECT * FROM {0} WHERE KindID={1}", GameKindItem.Tablename, kindID);
            GameKindItem kindInfo = platformFacade.GetEntity<GameKindItem>(sqlQuery.ToString());
            if (kindInfo != null)
            {
                if (!string.IsNullOrEmpty(kindInfo.GameRuleUrl))
                {
                    Response.Redirect(kindInfo.GameRuleUrl);
                    Response.End();
                }
            }
        }

        GameRulesInfo rules = webFacade.GetGameHelp(kindID);
        if (rules != null)
        {
            image = Server.UrlPathEncode(rules.ImgRuleUrl);
            intraduction = Utility.HtmlDecode(rules.HelpIntro);
            rule = Utility.HtmlDecode(rules.HelpRule);
            score = Utility.HtmlDecode(rules.HelpGrade);
            title = Utility.HtmlDecode(rules.KindName);

            this.divNoData.Visible = false;
            this.divMain.Visible = true;
        }
        else
        {
            this.divMain.Visible = false;
            this.divNoData.Visible = true;
        }

        Game.Web.Themes.Standard.Common_Header sHeader = (Game.Web.Themes.Standard.Common_Header)this.FindControl("sHeader");
        sHeader.title = "首页";
    }

</script>

<!DOCTYPE html>
<html>
<head runat="server">

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <link rel="stylesheet" type="text/css" href="/style/global_new.css" />
    <link href="/style/Iconfont/iconfont.css" rel="stylesheet" />
    <link href="/style/game_new.css" rel="stylesheet" />
    <script src="/js/jquery-1.10.2.min.js"></script>
</head>
<body>

    <qp:Header ID="sHeader" runat="server" />

    <!--页面主体开始-->
    <div class="main container" style="margin-top: 8px;">
        <!--左边部分开始-->
        <div class="left col-md-3">
            <div class="leftbar">
                <qp:GameSidebar ID="sGameSidebar" runat="server" />
            </div>
        </div>
        <!--左边部分结束-->

        <!--右边部分开始-->
        <div class="right  col-md-3">
            <!--游戏介绍内容开始-->
            <div class="recharge" id="divMain" runat="server">
                <div class="gameTitle hui3">
                    您的位置：首页 - 游戏介绍 - 
                <%= title %>
                </div>
                <div class="gameInfoBody">
                    <!--游戏截图开始-->
                    <div class="gameInfo">
                        <div class="err mtop13">游戏截图</div>
                        <div class="gameImg">
                            <img src="<%=image %>" width="431" height="295" />
                        </div>
                        <div class="clear"></div>
                    </div>
                    <!--游戏截图开始-->

                    <!--游戏介绍开始-->
                    <div class="gameInfo">
                        <div class="err mtop13">游戏介绍</div>
                        <div class="gameInfo mtop8 lineHeight22">
                            <%= intraduction %>
                        </div>
                        <div class="clear"></div>
                    </div>
                    <!--游戏介绍开始-->

                    <!--规则介绍开始-->
                    <div class="gameInfo">
                        <div class="err mtop13">规则介绍</div>
                        <div class="gameInfo mtop8 lineHeight22">
                            <%= rule %>
                        </div>
                        <div class="clear"></div>
                    </div>
                    <!--规则介绍开始-->

                    <!--积分等级开始-->
                    <div class="gameInfo">
                        <div class="err mtop13">积分等级</div>
                        <div class="gameInfo mtop8 lineHeight22">
                            <%= score %>
                        </div>
                        <div class="clear"></div>
                    </div>
                    <!--积分等级开始-->
                    <br />
                    <div class="clear"></div>
                </div>
                <div class="clear"></div>
                <div class="recharge2">
                    <div class="clear"></div>
                </div>
                <div class="clear"></div>
            </div>
            <!--游戏介绍内容结束-->

            <div id="divNoData" runat="server">抱歉，该游戏帮助还没有添加。</div>
            <div class="clear"></div>
        </div>
    </div>
    <!--页面主体结束-->
    <qp:Footer ID="sFooter" runat="server" />
</body>
</html>
