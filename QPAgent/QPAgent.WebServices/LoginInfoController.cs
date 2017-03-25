using System.Web;

namespace QPAgent.WebServices
{
    public class LoginInfoController : ControllerBase
    {
        public override string Index(HttpRequest req)
        {
            string roleName = "";
            if (userExt.RoleID == 1)
            {
                roleName = "超级管理员";
            }
            else
            {
                roleName = aidePlatformManagerFacade.GetRolenameByRoleID(userExt.RoleID);
            }
            bool IsAgent = aidePlatformManagerFacade.IsAgent(userExt.UserID);
            int AgentLevel = aidePlatformManagerFacade.GetAgentLevel(userExt.UserID);
            int ParentAgentID = aidePlatformManagerFacade.GetParentAgentID(userExt.UserID);
            SensitiveWordController swc = new SensitiveWordController();
            string json = swc.GetSensitiveWordSet();
            return JsonResultHelper.GetSuccessJsonByArray("{\"LoginInfo\":{\"UserID\":\"" + userExt.UserID + "\",\"UserName\":\"" + userExt.Username + "\",\"RoleID\":\"" + userExt.RoleID + "\",\"AgentLevel\":" + AgentLevel + ",\"RoleName\":\"" 
                + roleName + "\",\"IsAgent\":" + IsAgent.ToString().ToLower() + ",\"AgentID\":" + userExt.AgentID + ",\"ParentAgentID\":" + ParentAgentID + "},\"SenstWords\":" + json + "}");
        }
    }
}
