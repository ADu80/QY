using System;
using System.Web;

namespace Game.Web
{
    public class SystemGlobal
    {
        private const String _CURRENT_ADMINID = "_ADMINID_";
        private const String _CURRENT_ADMIN = "_ADMIN_";
        private const String _CURRENT_ADMINRID = "_ADMINRID_";
        private const String _CURRENT_VERIFYCODE = "_CHECKCODE_";
        public static int CURRENT_ADMINID
        {
            get
            {
                object obj = HttpContext.Current.Session[_CURRENT_ADMINID];
                return (obj == null ? -1 : Convert.ToInt32(obj));
            }
            set
            {
                HttpContext.Current.Session[_CURRENT_ADMINID] = value;
            }
        }
        public static int CURRENT_ADMINRID
        {
            get
            {
                object obj = HttpContext.Current.Session[_CURRENT_ADMINRID];
                return (obj == null ? -1 : Convert.ToInt32(obj));
            }
            set
            {
                HttpContext.Current.Session[_CURRENT_ADMINRID] = value;
            }
        }
        public static String CURRENT_ADMIN
        {
            get
            {
                object obj = HttpContext.Current.Session[_CURRENT_ADMIN];
                return (obj == null ? String.Empty : obj.ToString());
            }
            set
            {
                HttpContext.Current.Session[_CURRENT_ADMIN] = value;
            }
        }
        public static String CURRENT_VERIFYCODE
        {
            get
            {
                object obj = HttpContext.Current.Session[_CURRENT_VERIFYCODE];
                return (obj == null ? String.Empty : obj.ToString());
            }
            set
            {
                HttpContext.Current.Session[_CURRENT_VERIFYCODE] = value;
            }
        }
    }
}