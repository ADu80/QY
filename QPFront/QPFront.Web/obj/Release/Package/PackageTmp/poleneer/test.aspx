<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="pay.poleneer.test" %>

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
              rtype  <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox> 
              gameID  <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox> 
                amount  <asp:TextBox ID="TextBox3" runat="server"></asp:TextBox> 
                goodname  <asp:TextBox ID="TextBox4" runat="server"></asp:TextBox> 
&nbsp;<asp:Button ID="Button1" runat="server" Text="提交" OnClick="Button1_Click" />
                <asp:Image ID="Image1" runat="server" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
