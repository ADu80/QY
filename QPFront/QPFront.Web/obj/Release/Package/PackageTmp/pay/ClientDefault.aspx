<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClientDefault.aspx.cs" Inherits="pay.uka.ClientDefault" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta id="viewport" name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1; user-scalable=no;" />
    <title></title>
    <script src="js/GameValue.js" type="text/javascript"></script>
    <link href="css/Style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function altRows(id) {
            if (document.getElementsByTagName) {

                var table = document.getElementById(id);
                var rows = table.getElementsByTagName("tr");

                for (i = 0; i < rows.length; i++) {
                    if (i % 2 == 0) {
                        rows[i].className = "evenrowcolor";
                    } else {
                        rows[i].className = "oddrowcolor";
                    }
                }
            }
        }

        window.onload = function () {
            altRows('alternatecolor');
        }
    </script>
</head>
<body>
    <form id="Form1" runat="server" method="post">
        <asp:Panel ID="Panel1" runat="server">
    <br />
    <table class="altrowstable" width="100%">
        <tr>
            <td>
                请选择支付方式：网银支付
            </td>
        </tr>
    </table>
    <div>
        <div id="frm_payment">
            <div style="display: none;">
                商品名称：
            </div>
            <table width="100%" class="altrowstable" id="alternatecolor">
                <tr id="tr7">
                    <td>
                        <input type="radio" name="rtype" value="967" checked="checked" />工商银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="964" />农业银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="970" />招商银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="965" />建设银行
                    </td>
                </tr>
                <tr id="tr8">
                    <td>
                        <input type="radio" name="rtype" value="981" />交通银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="980" />民生银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="974" />深圳发展银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="963" />中国银行
                    </td>
                </tr>
                <tr id="tr9">
                    <td>
                        <input type="radio" name="rtype" value="962" />中信银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="972" />兴业银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="977" />浦发银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="986" />光大银行
                    </td>
                </tr>
                <tr id="tr10">
                    <td>
                        <input type="radio" name="rtype" value="989" />北京银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="988" />渤海银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="985" />广东发展银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="984" />广州市农信社
                    </td>
                </tr>
                <tr id="tr11">
                    <td class="style1">
                        <input type="radio" name="rtype" value="984" />广州市商业银行
                    </td>
                    <td class="style1">
                        <input type="radio" name="rtype" value="976" />上海农商银行
                    </td>
                    <td class="style1">
                        <input type="radio" name="rtype" value="973" />顺德农信社
                    </td>
                    <td class="style1">
                        <input type="radio" name="rtype" value="982" />华夏银行
                    </td>
                </tr>
                <tr id="tr12">
                    <td>
                        <input type="radio" name="rtype" value="979" />南京银行
                    </td>
                    <td>
                        <input type="radio" name="rtype" value="978" />平安银行
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
             <div class="div">
                <ul style="margin: 0 auto; padding: 0 auto; list-style: none">
                    
                    <li style="width: 100%; text-align: center; clear: both">
                        <asp:Button ID="Button1" runat="server" Text="立即支付" OnClientClick="return onFormSubmit();"
                            OnClick="Button1_Click" CssClass="btn" /> 
                    </li>
                </ul>
            </div>
        </div>
    </div></asp:Panel>
    </form>
</body>
</html>