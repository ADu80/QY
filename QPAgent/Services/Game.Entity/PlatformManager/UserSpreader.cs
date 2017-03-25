using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Entity.PlatformManager
{
    public class UserSpreader
    {
        public const string Tablename = "User_Spreader";
        public const string _UserID = "UserID";
        public const string _SpreaderID = "SpreaderID";
        public const string _Created = "Created";
        public const string _Creator = "Creator";
        public const string _Modified = "Modified";
        public const string _Modifior = "Modifior";

        public int UserID { get; set; }
        public int SpreaderID { get; set; }
        public DateTime Created { get; set; }
        public int Creator { get; set; }
        public DateTime Modified { get; set; }
        public int Modifior { get; set; }
    }
}
