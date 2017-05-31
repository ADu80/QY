using QPFront.Controller.Helpers;

namespace QPFront.Controller
{
    public class ControllerFactory
    {
        public static IController Create(string controller, string nameSpace = "QPFront.Controller")
        {
            string typeName = nameSpace + "." + controller + "Controller";
            IController cb = AssemblyFactory.Create<IController>(typeName);
            return cb;
        }
    }
}
