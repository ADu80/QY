using QPFront.Controller.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace QPFront.Controller
{
    public class AssemblyFactory
    {
        public static T Create<T>(string typeName)
        {
            Assembly assem = Assembly.GetCallingAssembly();
            object o = assem.CreateInstance(typeName);
            if (o == null)
                return default(T);
            return (T)o;
        }

        public static T Create<T>(string nameSpace, string typeName)
        {
            Assembly assem = Assembly.Load(nameSpace);
            object o = assem.CreateInstance(typeName);
            if (o == null)
                return default(T);
            return (T)o;
        }
    }
}
