using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QPFront.Controller.Helpers
{
    public class LogHelper
    {
        public static void WriteLog(string module, string log)
        {
            try
            {
                using (StreamWriter sw = File.AppendText(AppDomain.CurrentDomain.BaseDirectory + "\\debug.txt"))
                {
                    sw.WriteLine(module + "-----------------------------------------" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    sw.WriteLine(log);
                    sw.WriteLine("");
                }
            }
            catch (Exception)
            {

            }
        }
    }
}
