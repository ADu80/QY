namespace QPFront.Helpers
{
    public class JsonResultHelper
    {
        public static string GetSuccessJson(string data)
        {
            return "{\"status\":\"success\",\"message\":\"" + data + "\"}";
        }

        public static string GetSuccessJsonByArray(string arr)
        {
            return "{\"status\":\"success\",\"message\":" + arr + "}";
        }

        public static string GetErrorJson(string msg)
        {
            return "{\"status\":\"error\",\"message\":\"" + msg + "\"}";
        }

        public static string GetLoginErrorJson(string msg)
        {
            return "{\"status\":\"error\",\"expire\":true,\"message\":\"" + msg + "\"}";
        }
    }
}
