namespace PlatTaskService2
{
    partial class ProjectInstaller
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region 组件设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要修改
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.EmailServiceProcessInstaller2 = new System.ServiceProcess.ServiceProcessInstaller();
            this.EmailServiceInstaller2 = new System.ServiceProcess.ServiceInstaller();
            // 
            // EmailServiceProcessInstaller2
            // 
            this.EmailServiceProcessInstaller2.Account = System.ServiceProcess.ServiceAccount.LocalSystem;
            this.EmailServiceProcessInstaller2.Password = null;
            this.EmailServiceProcessInstaller2.Username = null;
            // 
            // EmailServiceInstaller2
            // 
            this.EmailServiceInstaller2.Description = "邮件服务2";
            this.EmailServiceInstaller2.DisplayName = "棋游邮件服务2";
            this.EmailServiceInstaller2.ServiceName = "EmailService2";
            // 
            // ProjectInstaller
            // 
            this.Installers.AddRange(new System.Configuration.Install.Installer[] {
            this.EmailServiceProcessInstaller2,
            this.EmailServiceInstaller2});

        }

        #endregion

        private System.ServiceProcess.ServiceProcessInstaller EmailServiceProcessInstaller2;
        private System.ServiceProcess.ServiceInstaller EmailServiceInstaller2;
    }
}