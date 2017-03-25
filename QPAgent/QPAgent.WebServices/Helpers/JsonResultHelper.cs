using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QPAgent.WebServices
{
    public class JsonResultHelper
    {
        public static string GetSuccessJson(string data)
        {
            return "{\"status\":\"success\",\"message\":\"" + data + "\"}";
        }

        public static string GetSuccessJsonByArray(string arr)
        {
            return "{\"status\":\"success\",\"message\":\"\",\"result\":" + arr + "}";
        }

        public static string GetErrorJson(string msg)
        {
            return "{\"status\":\"error\",\"message\":\"" + msg + "\"}";
        }

        public static string GetErrorJsonByArray(string msg)
        {
            return "{\"status\":\"error\",\"message\":\"" + msg + "\",\"result\":{data:[],totalPage:0,totalCount:0}}";
        }
        public static string GetLoginErrorJson(string msg)
        {
            return "{\"status\":\"error\",\"expire\":true,\"message\":\"" + msg + "\"}";
        }
        public static string GetLoginNoneJson(string msg)
        {
            return "{\"status\":\"none\",\"expire\":true,\"message\":\"" + msg + "\"}";
        }
    }
}
