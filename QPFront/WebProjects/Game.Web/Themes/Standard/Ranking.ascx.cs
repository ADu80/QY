using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Game.Facade;

namespace Game.Web.Themes.Standard
{
    public partial class Ranking : System.Web.UI.UserControl
    {
        protected void Page_Load( object sender , EventArgs e )
        {
            //财富排行
            TreasureFacade treasureFacade=new TreasureFacade();
            DataSet ds = treasureFacade.GetScoreRanking( 10 );
            rptScoreRanking.DataSource = ds;
            rptScoreRanking.DataBind();

            //魅力排行
            AccountsFacade accountsFacade = new AccountsFacade();
            ds = accountsFacade.GetLovesRanking( 10 );
            rptLovesRanking.DataSource = ds;
            rptLovesRanking.DataBind();
        }
    }
}