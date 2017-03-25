using Game.Facade;
using System.Data;
using System.Reflection;
using System.Web;

namespace Game.WebServices
{
    public abstract class ControllerBase : IController
    {
        public PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();

        public string ajax(ControllerBase controller, HttpRequest req)
        {
            string method = req["method"];
            string json = ExecuteMethod(controller, method, req);
            return json;
        }

        private string ExecuteMethod(ControllerBase controller, string method, HttpRequest req)
        {
            MethodInfo mi = controller.GetType().GetMethod(method);
            object r = mi.Invoke(controller, new object[] { req });
            return r.ToString();
        }        

        protected string GetJsonByDataTable(DataTable dt)
        {
            string strcol = "";
            string strrow = "";
            foreach (DataRow dr in dt.Rows)
            {
                strcol = "\"checked\":false,\"selected\":false,";
                foreach (DataColumn dc in dt.Columns)
                {
                    strcol += "\"" + dc.ColumnName + "\":\"" + dr[dc.ColumnName].ToString() + "\",";
                }
                strrow += "{" + strcol.Trim().Trim(',') + "},";
            }
            string json = "[" + strrow.Trim().Trim(',') + "]";
            return json;
        }
    }
}
