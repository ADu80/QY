using System.Reflection;

namespace QPAgent.WebServices
{
    public class AssemblyFactory
    {
        public static object Create(string nameSpace, string typeName)
        {
            object o = Assembly.GetCallingAssembly().CreateInstance(nameSpace + "." + typeName);
            return o;
        }

        public static T Create<T>(string nameSpace, string typeName)
        {
            object o = Assembly.GetCallingAssembly().CreateInstance(nameSpace + "." + typeName);
            if (o == null) return default(T);
            return (T)o;
        }

        public static T Create<T>(string dllName, string nameSpace, string typeName)
        {
            object o = Assembly.LoadFile(dllName).CreateInstance(nameSpace + "." + typeName);
            if (o == null) return default(T);
            return (T)o;
        }
    }
}
