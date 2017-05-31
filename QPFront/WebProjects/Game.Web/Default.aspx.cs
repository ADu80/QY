using Game.Facade;
using Game.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Game.Web
{
    public partial class Default : UCPageBase
    {
        private NativeWebFacade webFacade = new NativeWebFacade();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserLongout();
                BindNewsData();
                bindTreasureFacade();
                bindAccountsFacade();
                BindIssueData();
            }
        }

        /// <summary>
        /// 退出
        /// </summary>
        private void UserLongout()
        {
            string logout = GameRequest.GetQueryString("exit");
            if (logout == "true")
            {
                Fetch.DeleteUserCookie();
                Response.Redirect("/Index.aspx");
            }
        }

        /// <summary>
        /// 绑定新闻列表
        /// </summary>
        private void BindNewsData()
        {
            this.rptNews.DataSource = webFacade.GetTopNewsList(0, 0, 0, 5);
            this.rptNews.DataBind();
        }

        /// <summary>
        /// 获取新闻类型
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public string GetNewsType(object obj)
        {
            return Convert.ToInt32(obj) == 1 ? "新闻" : "公告";
        }

        //财富排行
        private void bindTreasureFacade()
        {
            //TreasureFacade treasureFacade = new TreasureFacade();
            //DataSet ds = treasureFacade.GetScoreRanking(10);
            //rptScoreRanking.DataSource = ds;
            //rptScoreRanking.DataBind();
        }


        //魅力排行
        private void bindAccountsFacade()
        {
            //AccountsFacade accountsFacade = new AccountsFacade();
            //DataSet ds = accountsFacade.GetLovesRanking(10);
            //rptLovesRanking.DataSource = ds;
            //rptLovesRanking.DataBind();
        }

        /// <summary>
        /// 问题列表
        /// </summary>
        private void BindIssueData()
        {
            rptIssueList.DataSource = webFacade.GetTopIssueList(5);
            rptIssueList.DataBind();
        }
    }
}