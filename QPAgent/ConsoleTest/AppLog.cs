using Game.Utils;
using System;
using System.IO;

namespace ConsoleTest
{
    public class AppLog
    {
        public static void SaveLog(string Module, string LogContent)
        {
            try
            {
                using (StreamWriter swr = File.AppendText(AppDomain.CurrentDomain.BaseDirectory + "\\log.txt"))
                {
                    swr.WriteLine(Module + "------------------------------------------" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    swr.WriteLine(LogContent);
                    swr.WriteLine();
                }
            }
            catch (Exception)
            {

            }
        }
    }
}
