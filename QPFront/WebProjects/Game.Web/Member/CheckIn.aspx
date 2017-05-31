<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CheckIn.aspx.cs" Inherits="Game.Web.Member.CheckIn" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="/style/check_in.css" type="text/css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
    <div class="bj">
        <div class="main">
            <div class="m_t"></div>
            <div class="m_b">
                <div class="fp">
                    <ul>
                        <li><asp:Button ID="btnDay1" runat="server" CssClass="ttp1" OnClientClick="return false;" hidefocus="false" style="outline: none" /><span class="zi">+<asp:Literal ID="litDay1" runat="server" Text="1000"></asp:Literal></span></li>
                        <li><asp:Button ID="btnDay2" runat="server" CssClass="ttp2" OnClientClick="return false;" hidefocus="false" style="outline: none" /><span class="zi">+<asp:Literal ID="litDay2" runat="server" Text="2000"></asp:Literal></span></li>
                        <li><asp:Button ID="btnDay3" runat="server" CssClass="ttp3" OnClientClick="return false;" hidefocus="false" style="outline: none" /><span class="zi">+<asp:Literal ID="litDay3" runat="server" Text="3000"></asp:Literal></span></li>
                        <li><asp:Button ID="btnDay4" runat="server" CssClass="ttp4" OnClientClick="return false;" hidefocus="false" style="outline: none" /><span class="zi">+<asp:Literal ID="litDay4" runat="server" Text="4000"></asp:Literal></span></li>
                        <li><asp:Button ID="btnDay5" runat="server" CssClass="ttp5" OnClientClick="return false;" hidefocus="false" style="outline: none" /><span class="zi">+<asp:Literal ID="litDay5" runat="server" Text="5000"></asp:Literal></span></li>
                        <li><asp:Button ID="btnDay6" runat="server" CssClass="ttp6" OnClientClick="return false;" hidefocus="false" style="outline: none" /><span class="zi">+<asp:Literal ID="litDay6" runat="server" Text="6000"></asp:Literal></span></li>
                        <li><asp:Button ID="btnDay7" runat="server" CssClass="ttp7" OnClientClick="return false;" hidefocus="false" style="outline: none" /><span class="zi">+<asp:Literal ID="litDay7" runat="server" Text="8000"></asp:Literal></span></li>
                    </ul>
                </div>
                <div class="tj">
                    <asp:Button ID="btnCheck" runat="server" CssClass="textput" OnClick="btnCheck_Click" />
                    <span class="ts">连续每天签到可获得更多奖励，最高每天 <asp:Literal ID="litDay77" runat="server" Text="8000"></asp:Literal> 游戏币奖励</span>
                </div>
                
            </div>
            <div class="m_d"></div>        
        </div>
    </div>
    </form>
</body>
</html>
