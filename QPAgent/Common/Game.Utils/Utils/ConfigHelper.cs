using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Utils.Utils
{
    public class ConfigHelper
    {
        public static string GetAppSetting(string key)
        {
            return System.Web.Configuration.WebConfigurationManager.AppSettings[key];
        }
    }
}
