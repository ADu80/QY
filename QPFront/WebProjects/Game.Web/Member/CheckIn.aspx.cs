using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Game.Facade;
using System.Text;
using System.Data;
using Game.Kernel;
using Game.Utils;

namespace Game.Web.Member
{
    public partial class CheckIn : UCPageBase
    {
        #region 继承属性

        protected override bool IsAuthenticatedUser
        {
            get
            {
                return true;
            }
        }

        #endregion

        #region 字段
        Dictionary<int, int> globalInfo = new Dictionary<int, int>();
        DataTable dtNow = null;
        DataTable dtBefore = null;
        TreasureFacade aideTreasureFacade = new TreasureFacade();
        #endregion

        #region 窗体事件
        protected void Page_Load( object sender, EventArgs e )
        {
            if( !IsPostBack )
            {
                GetGlobalInfo();
                GetPageInfo();
            }
        }

        /// <summary>
        /// 签到
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCheck_Click( object sender, EventArgs e )
        {
            //按钮状态
            btnCheck.Enabled = false;
            btnCheck.CssClass = "textput1";

            //新增记录
            Message msg = aideTreasureFacade.WriteCheckIn( Fetch.GetUserCookie().UserID, Utility.UserIP );
            if( msg.Success )
            {
                ShowAndRedirect( "领取成功", "CheckIn.aspx" );
            }
            else
            {
                Show( "领取失败，" + msg.Content );
            }
        }

        /// <summary>
        /// 增加页面标题
        /// </summary>
        protected override void AddHeaderTitle()
        {
            AddMetaTitle( "玩家签到 - " + ApplicationSettings.Get( "title" ) );
            AddMetaKeywords( ApplicationSettings.Get( "keywords" ) );
            AddMetaDescription( ApplicationSettings.Get( "description" ) );
        }
        #endregion

        #region 数据加载

        //获取奖励的配置信息
        private void GetGlobalInfo()
        {
            DataSet ds = aideTreasureFacade.GetDataSetByWhere( "SELECT * FROM GlobalCheckIn(NOLOCK)" );
            if( ds.Tables[0].Rows.Count != 7 )
            {
                globalInfo.Add( 1, 1000 );
                globalInfo.Add( 2, 2000 );
                globalInfo.Add( 3, 3000 );
                globalInfo.Add( 4, 4000 );
                globalInfo.Add( 5, 5000 );
                globalInfo.Add( 6, 6000 );
                globalInfo.Add( 7, 8000 );
            }
            else
            {
                foreach( DataRow dr in ds.Tables[0].Rows )
                {
                    globalInfo.Add( Convert.ToInt32( dr["ID"] ), Convert.ToInt32( dr["PresentGold"] ) );
                }
            }

            //加载图片信息
            int score = 0;
            for( int i = 1; i < globalInfo.Count + 1; i++ )
            {
                globalInfo.TryGetValue( i, out score );
                ( (Literal)Page.FindControl( "litDay" + i ) ).Text = score.ToString();
                if( i == globalInfo.Count )
                {
                    ( (Literal)Page.FindControl( "litDay" + i + i ) ).Text = score.ToString();
                }
            }
        }

        //获取当日页面状态
        private void GetPageInfo()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendFormat( "SELECT * FROM RecordCheckIn(NOLOCK) WHERE UserID={0} AND DATEDIFF(D,CollectDate,GETDATE())=0 ", Fetch.GetUserCookie().UserID );
            sb.AppendFormat( "SELECT * FROM RecordCheckIn(NOLOCK) WHERE UserID={0} AND DATEDIFF(D,CollectDate,GETDATE())=1", Fetch.GetUserCookie().UserID );
            DataSet ds = aideTreasureFacade.GetDataSetByWhere( sb.ToString() );
            dtNow = ds.Tables[0];
            dtBefore = ds.Tables[1];

            //判断页面状态
            int LxCount = 0;
            int bLxCount = 0;
            if( dtNow.Rows.Count == 0 )
            {
                //按钮状态
                btnCheck.Enabled = true;
                btnCheck.CssClass = "textput";

                //翻牌状态
                if( dtBefore.Rows.Count == 0 )
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
                    bLxCount = Convert.ToInt32( dtBefore.Rows[0]["LxCount"] );
                    if( bLxCount == 7 )
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
                        for( int i = 1; i < bLxCount + 1; i++ )
                        {
                            ( (Button)Page.FindControl( "btnDay" + i ) ).CssClass = "txtjb";
                            ( (Button)Page.FindControl( "btnDay" + ( i + 1 ) ) ).CssClass = "txtp" + ( i + 1 );
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
                LxCount = Convert.ToInt32( dtNow.Rows[0]["LxCount"] );
                for( int i = 1; i < LxCount + 1; i++ )
                {
                    ( (Button)Page.FindControl( "btnDay" + i ) ).CssClass = "txtjb";
                }
            }
        }
        #endregion
    }
}
