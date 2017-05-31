using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

using Game.Facade;
using System.Data;
using Game.Kernel;
using Game.Utils;
using Game.Entity.Accounts;

namespace Game.Web.PhoneService.CheckIn.iPhone
{
    public partial class CheckInInfo : System.Web.UI.Page
    {
        #region fields

        private const string cipherkey = "WHPhone6603";
        string p1 = AES.Decrypt(GameRequest.GetQueryString("P1"), cipherkey);
        string p2 = AES.Decrypt(GameRequest.GetQueryString("P2"), cipherkey);
        string p3 = AES.Decrypt(GameRequest.GetQueryString("P3"), cipherkey);        

        Dictionary<int, int> globalInfo = new Dictionary<int, int>();
        DataTable dtNow = null;
        DataTable dtBefore = null;
        TreasureFacade aideTreasureFacade = new TreasureFacade();
        #endregion

        #region 窗口事件

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckUserInfo();
                GetGlobalInfo();
                GetPageInfo();
            }
        }

        /// <summary>
        /// 签到
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCheck_Click(object sender, EventArgs e)
        {
            //按钮状态
            btnCheck.Enabled = false;
            btnCheck.CssClass = "textput1";
            
            //新增记录
            Message msg = aideTreasureFacade.WriteCheckIn(UserID, Utility.UserIP);
            if (msg.Success)
            {
                Response.Redirect(Request.Url.AbsoluteUri);
            }
            else
            {
                ShowAndRedirect("领取失败，" + msg.Content, Request.Url.AbsoluteUri);
            }
        }
        #endregion

        #region 数据加载

        //参数审核
        private void CheckUserInfo()
        {
            string authstr = Utility.MD5(p1 + p2);
            if (authstr != p3)
            {
                Response.Write( "<span style=\"color:red\">签名错误</span>" );
                //Response.Redirect("Error.htm");
            }
            else
            {
                //验证用户
                int userID = Utility.StrToInt(p1, 0);
                AccountsFacade accountsFacade = new AccountsFacade( );
                Message msg = accountsFacade.GetUserGlobalInfo(userID, 0, "");
                if (msg.Success)
                {
                    UserInfo user = msg.EntityList[0] as UserInfo;
                    if (user.LogonPass != p2)
                    {
                        Response.Write( "<span style=\"color:red\">密码错误</span>" );
                        //Response.Redirect("Error.htm");
                    }
                    else
                    {
                        UserID = userID;
                    }
                }
                else
                {
                    Response.Write( "<span style=\"color:red\">用户不存在</span>" );
                    //Response.Redirect("Error.htm");
                }
            }
        }

        //获取奖励的配置信息
        private void GetGlobalInfo()
        {
            DataSet ds = aideTreasureFacade.GetDataSetByWhere("SELECT * FROM GlobalCheckIn(NOLOCK)");
            if (ds.Tables[0].Rows.Count != 7)
            {
                globalInfo.Add(1, 1000);
                globalInfo.Add(2, 2000);
                globalInfo.Add(3, 3000);
                globalInfo.Add(4, 4000);
                globalInfo.Add(5, 5000);
                globalInfo.Add(6, 6000);
                globalInfo.Add(7, 8000);
            }
            else
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    globalInfo.Add(Convert.ToInt32(dr["ID"]), Convert.ToInt32(dr["PresentGold"]));
                }
            }

            //加载图片信息
            int score = 0;
            for (int i = 1; i < globalInfo.Count + 1; i++)
            {
                globalInfo.TryGetValue(i, out score);
                ((Literal)Page.FindControl("litDay" + i)).Text = score.ToString();
                if (i == globalInfo.Count)
                {
                    ((Literal)Page.FindControl("litDay" + i + i)).Text = score.ToString();
                }
            }
        }

        //获取当日页面状态
        private void GetPageInfo()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("SELECT * FROM RecordCheckIn(NOLOCK) WHERE UserID={0} AND DATEDIFF(D,CollectDate,GETDATE())=0 ", UserID);
            sb.AppendFormat("SELECT * FROM RecordCheckIn(NOLOCK) WHERE UserID={0} AND DATEDIFF(D,CollectDate,GETDATE())=1", UserID);
            DataSet ds = aideTreasureFacade.GetDataSetByWhere(sb.ToString());
            dtNow = ds.Tables[0];
            dtBefore = ds.Tables[1];

            //判断页面状态
            int LxCount = 0;
            int bLxCount = 0;
            if (dtNow.Rows.Count == 0)
            {
                //按钮状态
                btnCheck.Enabled = true;
                btnCheck.CssClass = "textput";

                //翻牌状态
                if (dtBefore.Rows.Count == 0)
                {
                    btnDay1.CssClass = "txtp1";
                    btnDay2.CssClass = "ttp2";
                    btnDay3.CssClass = "ttp3";
                    btnDay4.CssClass = "ttp4";
                    btnDay5.CssClass = "ttp5";
                    btnDay6.CssClass = "ttp6";
                    btnDay7.CssClass = "ttp7";
                }
                else
                {
                    bLxCount = Convert.ToInt32(dtBefore.Rows[0]["LxCount"]);
                    if (bLxCount == 7)
                    {
                        btnDay1.CssClass = "txtp1";
                        btnDay2.CssClass = "ttp2";
                        btnDay3.CssClass = "ttp3";
                        btnDay4.CssClass = "ttp4";
                        btnDay5.CssClass = "ttp5";
                        btnDay6.CssClass = "ttp6";
                        btnDay7.CssClass = "ttp7";
                    }
                    else
                    {
                        for (int i = 1; i < bLxCount + 1; i++)
                        {
                            ((Button)Page.FindControl("btnDay" + i)).CssClass = "txtjb";
                            ((Button)Page.FindControl("btnDay" + (i + 1))).CssClass = "txtp" + (i + 1);
                        }
                    }
                }
            }
            else
            {
                //按钮状态
                btnCheck.Enabled = false;
                btnCheck.CssClass = "textput1";

                //翻牌状态
                LxCount = Convert.ToInt32(dtNow.Rows[0]["LxCount"]);
                for (int i = 1; i < LxCount + 1; i++)
                {
                    ((Button)Page.FindControl("btnDay" + i)).CssClass = "txtjb";
                }
            }
        }
        #endregion

        #region 公共方法

        /// <summary>
        /// 显示消息提示对话框，并进行页面跳转
        /// </summary>
        /// <param name="page">当前页面指针，一般为this</param>
        /// <param name="msg">提示信息</param>
        /// <param name="url">跳转的目标URL</param>
        public void ShowAndRedirect(string msg, string url)
        {
            StringBuilder Builder = new StringBuilder();
            Builder.Append("<script language='javascript' defer>");
            Builder.AppendFormat("alert('{0}');", msg);
            Builder.AppendFormat("top.location.href='{0}'", url);
            Builder.Append("</script>");
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "message", Builder.ToString());

        }
        #endregion

        #region 公共属性

        private int UserID
        {
            get
            {
                if (ViewState["UserID"] == null)
                {
                    ViewState["UserID"] = 0;
                }

                return (int)ViewState["UserID"];
            }
            set
            {
                ViewState["UserID"] = value;
            }
        }
        #endregion
    }
}
