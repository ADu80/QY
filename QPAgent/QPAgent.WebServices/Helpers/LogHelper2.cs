using System;

namespace QPAgent.WebServices.Helpers
{
    public enum LogOperationEnum
    {
        AddAgent = 1,
        EditAgent = 2,
        AddGamer = 3,
        AddAdmin = 4,
        EditAdmin = 5,
        DeleteAdmin = 6,
        ChangeAdminRole = 7,
        ChangeAdminPassword = 8,
        NullityAdmin = 9,
        NoNullityAdmin = 10,
        AddRole = 11,
        EditRole = 12,
        DeleteRole = 13,
        Logout = 14,
        Login = 15,
        SpreadOption = 16,
        EditSensitiveWord = 17
    }

    public class LogHelper2
    {
        public static void SaveSuccessLog(string logContent, int iOperator, int iOperation, string loginIP, string module)
        {
            try
            {
                ControllerBase.aidePlatformManagerFacade.AddLog(iOperator, iOperation, logContent + "，操作成功", loginIP, module);
            }
            catch (Exception)
            {

            }
        }
        public static void SaveErrLog(string logContent, string errMsg, int iOperator, int iOperation, string loginIP, string module)
        {
            try
            {
                ControllerBase.aidePlatformManagerFacade.AddLog(iOperator, iOperation, logContent + (errMsg == "" ? "" : "，操作失败：" + errMsg), loginIP, module);
            }
            catch (Exception)
            {

            }
        }
    }
}
