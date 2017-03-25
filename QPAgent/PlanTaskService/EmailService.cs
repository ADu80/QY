using System.ServiceProcess;

namespace PlanTaskService
{
    public partial class EmailService : ServiceBase
    {
        public EmailService()
        {
            InitializeComponent();
        }

        System.Timers.Timer timer = null;
        protected override void OnStart(string[] args)
        {
            EmailTask emTask = new EmailTask();
            timer = new System.Timers.Timer(1000);//每秒
            timer.Enabled = true;
            timer.Elapsed += new System.Timers.ElapsedEventHandler(emTask.RunTask);
            timer.AutoReset = true;
            timer.Start();

        }

        protected override void OnStop()
        {
            if (timer != null)
            {
                timer.Stop();
                timer.Close();
            }
        }
    }
}
