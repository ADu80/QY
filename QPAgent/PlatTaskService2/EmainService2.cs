using System.ServiceProcess;

namespace PlatTaskService2
{
    public partial class EmainService2 : ServiceBase
    {
        public EmainService2()
        {
            InitializeComponent();
        }

        System.Timers.Timer timer = null;
        protected override void OnStart(string[] args)
        {
            PlanTaskService2.EmailTask emTask = new PlanTaskService2.EmailTask();
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
