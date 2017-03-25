using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QPAgent.WebServices
{
    public class ControllerFactory
    {
        public static ControllerBase Create(string controller)
        {
            var o = AssemblyFactory.Create("QPAgent.WebServices", controller + "Controller");
            return (ControllerBase)o;           
        }
    }
}
