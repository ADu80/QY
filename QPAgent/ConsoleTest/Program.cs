using Game.Facade;
using System;
using System.Threading;

namespace ConsoleTest
{
    class Program
    {
        static void Main(string[] args)
        {
            Task.StartSendSpreadSumEmail();
            Console.WriteLine("Hello World...");
            Console.ReadKey();
        }
    }

    public class Task
    {
        public static void StartSendSpreadSumEmail()
        {
            new Thread(() =>
            {
                try
                {
                    string date = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
                    SendSpreadSumEmail(date);
                }
                catch (Exception ex)
                {
                    AppLog.SaveLog("发送邮件", ex.Message);
                }
            }).Start();
        }

        static void SendSpreadSumEmail(string today)
        {
            PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();
            aidePlatformManagerFacade.AddSpreadSumEmail(today);
            aidePlatformManagerFacade.AddAgentReveneSumEmail(today);
        }
    }
}
