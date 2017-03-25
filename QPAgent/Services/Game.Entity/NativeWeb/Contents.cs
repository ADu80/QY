using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Game.Entity.NativeWeb
{
    public class Contents
    {
        #region 常量

        /// <summary>
        /// 表名
        /// </summary>
        public const string Tablename = "Content";

        /// <summary>
        /// 用户标识
        /// </summary>
        public const string _id = "id";


        public const string _TitleName = "TitleName";


        public const string _DowUrl = "DowUrl";


        public const string _Images = "Images";


        public const string _Description = "Description";


        public const string _TypeId = "TypeId";


        public const string _PackageId = "PackageId";


        public const string _PackageName = "PackageName";

        public const string _addtime = "addtime";

        public const string _iosAppName= "iosAppName";
        public const string _iosIpaUrl = "iosIpaUrl";


        #endregion


        /// <summary>
        /// 无参构造方法
        /// </summary>
        public Contents()
        {
        }



        /// <summary>
        /// 指定字段的构造方法
        /// </summary>
        public Contents(int id, string titleName, string dowUrl, string images, string description, int typeId, int packageId, string packageName, string iosAppName, string iosIpaUrl)
        {
            this.id = id;
            this.titleName = titleName;
            this.dowUrl = dowUrl;
            this.images = images;
            this.description = description;
            this.typeId = typeId;
            this.packageId = packageId;
            this.packageName = packageName;
            this.packageId = packageId;
            this.packageName = packageName;
            this.iosAppName = iosAppName;
            this.iosIpaUrl = iosIpaUrl;
        }



        private string iosAppName;

        public string IosAppName
        {
            get
            {
                return iosAppName;
            }
            set
            {
                iosAppName = value;
            }
        }

        private string iosIpaUrl;

        public string IosIpaUrl
        {
            get
            {
                return iosIpaUrl;
            }
            set
            {
                iosIpaUrl = value;
            }
        }

        private DateTime addtime;

        public DateTime Addtime
        {
            get
            {
                return addtime;
            }
            set
            {
                addtime = value;
            }
        }

        private int id;
        public int Id
        {
            get
            {
                return id;
            }
            set
            {
                id = value;
            }
        }

        private string titleName;
        public string TitleName
        {
            get
            {
                return titleName;
            }
            set
            {
                titleName = value;
            }
        }

        private string dowUrl;
        public string DowUrl
        {
            get
            {
                return dowUrl;
            }
            set
            {
                dowUrl = value;
            }
        }

        private string images;
        public string Images
        {
            get
            {
                return images;
            }
            set
            {
                images = value;
            }
        }

        private string description;
        public string Description
        {
            get
            {
                return description;
            }
            set
            {
                description = value;
            }
        }

        private int typeId;
        public int TypeId
        {
            get
            {
                return typeId;
            }
            set
            {
                typeId = value;
            }
        }

        private int packageId;
        public int PackageId
        {
            get
            {
                return packageId;
            }
            set
            {
                packageId = value;
            }
        }

        private string packageName;
        public string PackageName
        {
            get
            {
                return packageName;
            }
            set
            {
                packageName = value;
            }
        }
    }
}
