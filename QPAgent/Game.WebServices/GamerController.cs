using System;
using System.Web;

namespace Game.WebServices
{
    public class GamerController : ControllerBase
    {
        public string GetInitCode(HttpRequest req)
        {
            object oUserID = req["userid"];
            int UserID = 0;
            if (oUserID != null && oUserID.ToString().Trim() != "")
                UserID = Convert.ToInt32(oUserID);
            return aidePlatformManagerFacade.GetInitCodebyUserID(UserID);
        }
    }
}