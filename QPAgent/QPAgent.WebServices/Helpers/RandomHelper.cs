using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace QPAgent.WebServices
{
    public class RandomHelper
    {
        public static List<int> SpreaderIDArr { get; set; }

        public static int[] SkipArr = new int[] { 8888, 88888, 888888 };

        const int MAXLENGTH = 999999;

        public static void Init()
        {
            //SpreaderIDArr = new List<int>();
            //DataTable dt = ControllerBase.aidePlatformManagerFacade.GetUserSpreader();
            //for (int i = 1000; i < MAXLENGTH; i++)
            //{
            //    if (SkipArr.Contains(i))
            //        continue;
            //    if (dt.Select("SpreaderID=" + i).Length > 0)
            //        continue;
            //    SpreaderIDArr.Add(i);
            //}
        }

        public static void Refresh()
        {
            //SpreaderIDArr.Clear();
            //DataTable dt = ControllerBase.aidePlatformManagerFacade.GetUserSpreader();
            //for (int i = 1000; i < MAXLENGTH; i++)
            //{
            //    if (SkipArr.Contains(i))
            //        continue;
            //    SpreaderIDArr.Add(i);
            //}
        }
    }
}
