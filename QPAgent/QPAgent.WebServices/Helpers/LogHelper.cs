using Game.Utils;
using System;
using System.IO;
using System.Runtime.Remoting.Contexts;
using System.Runtime.Remoting.Messaging;

namespace QPAgent.WebServices.Helpers
{
    //业务层的类和方法
    [LogInterceptor]
    public class BusinessHandler : ContextBoundObject
    {
        [Log]
        public void DoSomething()
        {
            Console.WriteLine("执行了方法本身！");
        }
    }

    //贴在类上的标签
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
    public sealed class LogInterceptorAttribute : ContextAttribute, IContributeObjectSink
    {
        public LogInterceptorAttribute()
            : base("MyInterceptor")
        { }

        //实现IContributeObjectSink接口当中的消息接收器接口
        public IMessageSink GetObjectSink(MarshalByRefObject obj, IMessageSink next)
        {
            return new LogAopHandler(next);
        }
    }

    //贴在方法上的标签
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
    public sealed class LogAttribute : Attribute
    {
        public string Module { get; set; }
        public string LogContent { get; set; }
    }

    //AOP方法处理类，实现了IMessageSink接口，以便返回给IContributeObjectSink接口的GetObjectSink方法
    public sealed class LogAopHandler : IMessageSink
    {
        //下一个接收器
        private IMessageSink nextSink;
        public IMessageSink NextSink
        {
            get { return nextSink; }
        }
        public LogAopHandler(IMessageSink nextSink)
        {
            this.nextSink = nextSink;
        }

        //同步处理方法
        public IMessage SyncProcessMessage(IMessage msg)
        {
            IMessage retMsg = null;

            //方法调用消息接口
            IMethodCallMessage call = msg as IMethodCallMessage;

            //如果被调用的方法没打MyInterceptorMethodAttribute标签
            Attribute attr = (Attribute.GetCustomAttribute(call.MethodBase, typeof(LogAttribute)));
            if (call == null || attr == null)
            {
                retMsg = nextSink.SyncProcessMessage(msg);
            }
            //如果打了MyInterceptorMethodAttribute标签
            else
            {
                //Console.WriteLine("执行之前");

                retMsg = nextSink.SyncProcessMessage(msg);

                //Console.WriteLine("执行之后");
                LogAttribute log = (LogAttribute)attr;
                SaveLog(log.Module, log.LogContent);
            }

            return retMsg;
        }

        void SaveLog(string Module, string LogContent)
        {
            try
            {
                string loginIP = GameRequest.GetUserIP();
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

        //异步处理方法（不需要）
        public IMessageCtrl AsyncProcessMessage(IMessage msg, IMessageSink replySink)
        {
            return null;
        }
    }
}
