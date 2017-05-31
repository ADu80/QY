using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Game.Facade;
using Game.Utils;
using Game.Entity.Treasure;
using Game.Kernel;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Game.Web.AppPay
{
    public partial class ProductList : System.Web.UI.Page
    {
        #region Fields

        int tagID = GameRequest.GetQueryInt("TagID", 0);
        TreasureFacade treasureFacade = new TreasureFacade();

        #endregion

        #region 窗口事件

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Response.Write(PayApp());
                Response.End();
            }
        }
        #endregion

        #region 公共方法

        private string PayApp()
        {
            DataSet ds = treasureFacade.GetAppListByTagID(tagID);
            string rValue = JsonConvert.SerializeObject(ds);
            return rValue;
        }

        #endregion
    }
}
