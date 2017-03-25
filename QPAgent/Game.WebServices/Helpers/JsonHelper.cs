using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;

namespace Game.WebServices
{
    public class JsonHelper
    {
        public static Dictionary<string, object> ToDictionary(string json)
        {
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Dictionary<string, object> dic = jss.Deserialize<Dictionary<string, object>>(json);
            return dic;
        }

        public static object GetSingleItemValue(string json, string key)
        {
            var kvi = ToDictionary(json).Where(kv => { return kv.Key == key; }).FirstOrDefault();
            return kvi.Value;
        }
    }
}
