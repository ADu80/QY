<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Ranking.ascx.cs" Inherits="Game.Web.Themes.Standard.Ranking" %>
<%@ OutputCache Duration="21600" VaryByParam="none" %>
<div class="serve mtop10">
    <div class="serve-title serve1 bold hui3 ">玩家排行榜</div>
    <div class="serve-tab tab">
        <div class="tabpage-active tab1" id="divScore">财富排行</div>
        <div class="tabpage tab2" id="divLoves">魅力排行</div>
    </div>
    <div class="serve-content topBg">
        <ul id="ulScoreOrderBy">
            <asp:Repeater runat="server" ID="rptScoreRanking">
                <ItemTemplate>
                    <li title="<%# Eval("NickName") %>">
                        <span class="hui6"><%# Eval("Score") %></span>
                        <div style="width: 70px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 500;"><%# Eval("NickName") %></div>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
        <ul id="ulLovesOrderBy" style="display: none;">
            <asp:Repeater runat="server" ID="rptLovesRanking">
                <ItemTemplate>
                    <li title="<%# Eval("NickName") %>">
                        <span class="hui6"><%# Eval( "LoveLiness" )%></span>
                        <div style="width: 70px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 500;"><%# Eval("NickName") %></div>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
    </div>
    <div class="clear"></div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $("#divScore").click(function () {
            $(this).removeClass('tabpage');
            $(this).addClass('tabpage-active');
            $("#divLoves").removeClass('tabpage-active');
            $("#divLoves").addClass('tabpage');
            $("#ulScoreOrderBy").show();
            $("#ulLovesOrderBy").hide();
        });
        $("#divLoves").click(function () {
            $(this).removeClass('tabpage');
            $(this).addClass('tabpage-active');
            $("#divScore").removeClass('tabpage-active');
            $("#divScore").addClass('tabpage');

            $("#ulLovesOrderBy").show();
            $("#ulScoreOrderBy").hide();
        });
    });
</script>
