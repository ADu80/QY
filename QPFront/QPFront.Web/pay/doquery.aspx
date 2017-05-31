<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="doquery.aspx.cs" Inherits="pay.uka.doquery" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="css/Style.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <br />
    <table class="altrowstable" width="100%">
        <tr>
            <td>
                订单编号：<asp:TextBox ID="orderid" runat="server"></asp:TextBox>
                &nbsp;<asp:Literal ID="Literal1" runat="server"></asp:Literal>
&nbsp;<asp:Button ID="Button1" runat="server" Text="查询" OnClick="Button1_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
