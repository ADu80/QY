using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Text;
using Game.Utils;
using System.Web.UI.WebControls;
using System.Data;
using Game.Kernel;
using System.Configuration;

namespace Game.Web
{
    public partial class BasePage : System.Web.UI.Page
    {
        protected static string FullPath = string.Empty;
        
        protected static bool IsHidden
        {
            get
            {
                object obj = ConfigurationManager.AppSettings["IsHidden"];
                return obj == null ? false : true;
            }
        }
        protected static bool IsEmail
        {
            get
            {
                object obj = ConfigurationManager.AppSettings["IsEmail"];
                return obj == null ? false : true;
            }
        }
        protected string relId = string.Empty;
        protected int numPerPage = 30;
        protected int pageNum = 1;
        protected int Total = 0;
        protected string keyWord = string.Empty;
        protected string OrderField = string.Empty;
        protected string OrderDirection = string.Empty;
        protected string OrderBy = string.Empty;
        protected StringBuilder strWhere = null;

        protected void PageBind(Repeater rpt, PagerSet pageSet)
        {
            rpt.DataSource = pageSet.PageSet;
            Total = pageSet.RecordCount;
            rpt.DataBind();
        }
        protected void PageBind(Repeater rpt, DataSet dataSet)
        {
            rpt.DataSource = dataSet.Tables[0];
            Total = int.Parse(dataSet.Tables[1].Rows[0][0].ToString());
            rpt.DataBind();
        }
        #region Ajax输出
        /// <summary>
        /// ajax请求输出
        /// </summary>
        /// <param name="ContentType">输出内容类型</param>
        /// <param name="obj">输出值</param>
        protected void outputobject(string ContentType, object obj)
        {
            HttpContext.Current.Response.ContentEncoding = Encoding.GetEncoding("UTF-8");
            HttpContext.Current.Response.ContentType = ContentType;
            HttpContext.Current.Response.StatusCode = 200;
            HttpContext.Current.Response.Write(obj);
            HttpContext.Current.Response.End();
        }
        /// <summary>
        /// ajax请求输出
        /// </summary>
        /// <param name="obj">输出值,text/plain类型</param>
        protected void outputobject(object obj)
        {
            outputobject("text/plain", obj);
        }
        /// <summary>
        /// ajax请求输出
        /// </summary>
        /// <param name="obj">输出javascript值,text/html类型</param>
        protected void outputJscript(object textJs)
        {
            StringBuilder sBuilder = new StringBuilder();
            sBuilder.Append("<script type=\"text/javascript\" language=\"javascript\">").Append(textJs).Append("</script>");
            outputobject("text/html", sBuilder);
        }
        /// <summary>
        /// ajax请求输出
        /// </summary>
        /// <param name="obj">输出json值,text/plain类型</param>
        protected void outputJson(Object obj)
        {
            outputobject("text/plain", JsonConvert.SerializeObject(obj));
        }
        protected void outputTableToJson(DataTable dt)
        {
            string result = JsonConvert.SerializeObject(dt, new DataTableConverter()).Replace("\"","");
            outputobject("text/plain", JsonConvert.SerializeObject(result));
        }
        /// <summary>
        /// 序列化dataset分页数据
        /// ds.Tables[0]总个数 total
        /// ds.Tables[1]分页数据 rows
        /// </summary>
        /// <param name="ds">dataset分页数据</param>
        protected void outputpage(System.Data.DataSet ds)
        {
            StringBuilder sBuilder = new StringBuilder();
            sBuilder.Append("\"total\":").Append(JsonConvert.SerializeObject(ds.Tables[0])).Append(",").Append("\"rows\":").Append(JsonConvert.SerializeObject(ds.Tables[1]));
            outputobject(sBuilder);
        }
        #endregion
    }
}