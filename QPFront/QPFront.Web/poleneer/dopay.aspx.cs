using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Net;
using System.Text;
using System.IO;
using System.Web.Script.Serialization;
using System.Drawing;
using ThoughtWorks.QRCode.Codec;
using QPFront.Controller;

namespace pay.poleneer
{
    public partial class dopay : System.Web.UI.Page
    {
       
        protected void Page_Load(object sender, EventArgs e)
        {
            Panel1.Visible = true;
            if (Request["btype"] == "1") {
                Literal2.Text = "支付宝";
                Literal1.Text = "支付宝";
            } else {
                Literal2.Text = "微信";
                Literal1.Text = "微信";
            }
            Image1.ImageUrl = Request["url"];

        }
         
    }
}