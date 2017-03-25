using Game.Facade;
using System;
using System.Threading;

namespace PlanTaskService
{
    public class EmailTask
    {
        public void RunTask(object sender, System.Timers.ElapsedEventArgs e)
        {
            try
            {
                System.Timers.Timer timer = (System.Timers.Timer)sender;
                string time = DateTime.Now.ToString("HH:mm:ss");
                string stime = DateTime.Now.ToString("mm:ss");
                string content = "";
                if (time.StartsWith("00:"))
                {
                    StartSendSpreadSumEmail();
                    SetInterval(timer, 86400000);
                    content = "每天进行：" + timer.Interval;
                }
                else if (stime.StartsWith("00:"))
                {
                    StartSendSpreadSumEmail();
                    SetInterval(timer, 3600000);
                    content = "每小时进行：" + timer.Interval;
                }
                else
                {
                    SetInterval(timer, 60000);
                    content = "每分钟进行：" + timer.Interval;
                }
                AppLog.SaveLog("发送邮件", content);
            }
            catch (Exception ex)
            {
                AppLog.SaveLog("发送邮件", ex.Message);
            }
        }

        void SetInterval(System.Timers.Timer timer, int interval)
        {
            if (timer.Interval != interval)
            {
                timer.Stop();
                timer.Interval = interval;//一天执行一次
                timer.Start();
            }
        }

        void StartSendSpreadSumEmail()
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

        void SendSpreadSumEmail(string today)
        {
            PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();
            aidePlatformManagerFacade.AddSpreadSumEmail(today);
            aidePlatformManagerFacade.AddAgentReveneSumEmail(today);
        }
    }
}