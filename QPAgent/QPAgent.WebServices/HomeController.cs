using Game.Entity.PlatformManager;
using Game.Facade;
using System.Data;
using System.Web;
using System;

namespace QPAgent.WebServices
{
    public class HomeController : ControllerBase
    {
        protected string GetCondition(HttpRequest req)
        {
            return "";
        }

        public override string Index(HttpRequest req)
        {
            DataTable dt = null;
            if (userExt.AgentID == 0)
            {
                dt = aideTreasureFacade.GetStatInfo().Tables[0];
            }
            else
            {
                dt = aideTreasureFacade.GetStatInfo2(userExt.UserID).Tables[0];
            }
            string json = "";
            return json;
        }

        public override string New(HttpRequest req)
        {
            string json = "";
            return json;
        }

        public override string Edit(HttpRequest req)
        {
            string json = "";
            return json;
        }

        public override string Delete(HttpRequest req)
        {
            string json = "";
            return json;
        }
    }
}
