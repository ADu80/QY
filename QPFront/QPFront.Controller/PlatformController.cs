using QPFront.Helpers;
using System;
using System.Data;
using System.Web;

namespace QPFront.Controller
{
    public class PlatformController : ControllerBase, IController
    {
        public string ShopProperty(HttpRequest req)
        {
            DataTable dt = aidePlatformFacade.GetShopProperty();

            string json = GetJsonByDataTable(dt);
            return JsonResultHelper.GetSuccessJsonByArray(json);
        }

        public string Add(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public string Delete(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public string Index(HttpRequest req)
        {
            throw new NotImplementedException();
        }

        public string Update(HttpRequest req)
        {
            throw new NotImplementedException();
        }
    }
}
