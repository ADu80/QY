using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Web;

using Game.Utils;
using Game.Entity.NativeWeb;

namespace Game.Facade.Files
{
    /// <summary>
    /// 文件管理 (Http 方式)
    /// </summary>
    public class HttpFileManager
    {
        #region Fields

        private string m_value;
        private bool m_access;
        private string m_folderPath;            //当前目录 绝对路径
        private string m_uploadFilePath;        //上传文件路径    
        //private byte[] m_uploadFilePathbyte;

       
        private int m_folderCount;
        private int m_FileCount;

        private int newsid;

        public int Newsid
        {
            get
            {
                return newsid;
            }
            set
            {
                newsid = value;
            }
        }

        #endregion

        #region 构造方法

        /// <summary>
        /// 初始化文件管理 (Http 方式)
        /// </summary>
        public HttpFileManager()
        {
            m_value = "";
            m_access = false;
            m_folderPath = "";
            m_folderCount = 0;
            m_FileCount = 0;

            HttpRequest Request = HttpContext.Current.Request;
            m_folderPath = Request.QueryString["path"];
        }

        /// <summary>
        /// 初始化文件管理 (Http 方式)
        /// </summary>
        /// <param name="p_act">处理选项</param>
        public HttpFileManager(string p_act)
        {
            HttpRequest Request = HttpContext.Current.Request;
            m_folderPath = Request.QueryString["path"];

            switch (p_act)
            {
                case "create":
                    CreateFolder();
                    break;
                case "delete":
                    DeleteFileFolder();
                    break;
                case "upload":
                    UploadFile();
                    break;
                case "uploadToByte":
                    UploadFile();
                   // UploadFileToByte();
                    break;
            }
        }

        #endregion

        #region 公开属性

        /// <summary>
        /// 处理结果
        /// </summary>
        public string Value
        {
            get { return m_value; }
        }

        /// <summary>
        /// 上传文件路径
        /// </summary>
        public string UploadFilePath
        {
            get { return m_uploadFilePath; }
        }

        /// <summary>
        /// 上传文件路径2
        /// </summary>
        //public byte[] UploadFilePathbyte
        //{
        //    get
        //    {
        //        return m_uploadFilePathbyte;
        //    }
        //}

        /// <summary>
        /// 访问权限
        /// </summary>
        public bool Access
        {
            get { return m_access; }
        }

        /// <summary>
        /// 目录数目
        /// </summary>
        public int FolderCount
        {
            get { return m_folderCount; }
        }

        /// <summary>
        /// 文件数目
        /// </summary>
        public int FileCount
        {
            get { return m_FileCount; }
        }

        #endregion

        #region 公开方法

        /// <summary>
        /// 获取目录下所有文件
        /// </summary>
        /// <param name="folderPath">目录路径</param>
        /// <param name="rootPath">根路径</param>
        /// <returns>List FileInfo</returns>
        public List<HttpFolderInfo> GetDirectories(string folderPath, string rootPath)
        {
            StringBuilder urlFormat = new StringBuilder();
            string orderBy = GameRequest.GetQueryString("order");

            List<HttpFolderInfo> httpFolderList = new List<HttpFolderInfo>();
            IList<FolderInfo> folderList = FileManager.GetDirectoryFilesListForObject(folderPath, FsoMethod.All);
            if (folderList == null || folderList.Count <= 0)
            {
                //无文件访问权限
                m_access = false;
                return httpFolderList;
            }

            //文件信息转换
            foreach (FolderInfo folderInfo in folderList)
            {
                //删除 Builder
                urlFormat.Remove(0, urlFormat.Length);

                //目录
                if (folderInfo.FsoType == FsoMethod.Folder)
                {
                    urlFormat
                        .AppendFormat("<a href=\"Web_FilesManager.aspx?path={0}\">", Utility.UrlEncode(rootPath + "/" + folderInfo.Name))
                        .AppendFormat("<img src=\"images/attach/files/folder.gif\" alt=\"文件夹\" align=\"absmiddle\" /> {0} </a>", folderInfo.Name)
                        .AppendFormat(" <a href=\"Web_FilesManager.aspx?act=compress&amp;path={0}&amp;objfolder={1}\" onclick=\"javascript:compressMsg();\">", Utility.UrlEncode(m_folderPath), Utility.UrlEncode(folderInfo.FullName));

                    HttpFolderInfo httpFolder = new HttpFolderInfo(folderInfo.Name, Utility.UrlEncode(folderInfo.FullName), urlFormat.ToString(), "", 0, "folder", folderInfo.LastWriteTime);
                    httpFolderList.Add(httpFolder);

                    m_folderCount++;
                }

                //文件
                if (folderInfo.FsoType == FsoMethod.File)
                {
                    if (TextUtility.InArray(folderInfo.ContentType, "jpg,gif,png,bmp,psd", ",", true))
                    {
                        urlFormat
                            .AppendFormat("<a href=\"javascript:void(0);\" onclick=\"showPopWin('Web_FilesView.aspx?url=file.axd?file={0}',700,433,null);\">", Utility.UrlEncode(rootPath + "/" + folderInfo.Name))
                            .AppendFormat("<img src=\"images/attach/files/{1}.gif\" alt=\"文件\" align=\"absmiddle\" /> {0}</a>", folderInfo.Name, folderInfo.ContentType);
                    }
                    else
                    {
                        urlFormat
                            .AppendFormat("<a href=\"file.axd?file={0}\" target=\"_new\">", Utility.UrlEncode(rootPath + "/" + folderInfo.Name));


                        string logo = "default";
                        switch (folderInfo.ContentType)
                        {
                            case "mp3":
                            case "wav":
                            case "wma":
                            case "wmv":
                                logo = "mp3";
                                break;

                            case "zip":
                            case "7z":
                            case "rar":
                                logo = "zip";
                                break;
                        }

                        if (!TextUtility.EmptyTrimOrNull(folderInfo.ContentType) && TextUtility.InArray(folderInfo.ContentType, "css,dll,doc,docx,swf,txt,xls,xlsx,xml", ",", true))
                        {
                            logo = folderInfo.ContentType;
                        }

                        urlFormat.AppendFormat("<img src=\"images/attach/files/{1}.gif\" alt=\"文件\" align=\"absmiddle\" /> {0}</a>", folderInfo.Name, logo);
                    }

                    HttpFolderInfo httpFolder = new HttpFolderInfo(folderInfo.Name, Utility.UrlEncode(folderInfo.FullName), urlFormat.ToString(), folderInfo.ContentType, folderInfo.Length, "file", folderInfo.LastWriteTime);
                    httpFolderList.Add(httpFolder);

                    m_FileCount++;
                }
            }

            //具有文件访问权限
            m_access = true;

            if (!TextUtility.EmptyTrimOrNull(orderBy))
                httpFolderList.Sort(new FilesComparer(orderBy));

            return httpFolderList;
        }

        /// <summary>
        /// 创建目录
        /// </summary>
        private void CreateFolder()
        {
            string folderName = GameRequest.GetFormString("txtFolderName");
            string serverPath = TextUtility.GetRealPath(m_folderPath);

            if (TextUtility.EmptyTrimOrNull(folderName))
            {
                m_value = "目录名不能为空";
                return;
            }

            DirectoryInfo dir = new DirectoryInfo(serverPath + "\\" + folderName);
            if (dir.Exists)
            {
                m_value = "目录名已存在";
            }
            else
            {
                try
                {
                    dir.Create();
                    m_value = "创建目录成功, 目录名称为: " + folderName;
                }
                catch
                {
                    m_value = "创建目录失败, 权限不足";
                }
            }
        }

        /// <summary>
        /// 删除文件, 目录
        /// </summary>
        private void DeleteFileFolder()
        {
            string delClientName = GameRequest.GetQueryString(HttpContext.Current.Request, "file");
            string delName = TextUtility.GetRealPath(delClientName);
            string delType = GameRequest.GetQueryString(HttpContext.Current.Request, "type");

            //限定删除文件的路径
            if (TextUtility.EmptyTrimOrNull(delClientName) || !delClientName.StartsWith("/upload"))
            {
                m_value = "要删除的文件不存在";
                return;
            }

            if (delType == "file")
            {
                if (File.Exists(delName))
                {
                    try
                    {
                        File.Delete(delName);
                        m_value = "删除文件成功, 被删除的文件为: " + Path.GetFileName(delName);
                    }
                    catch
                    {
                        m_value = "删除文件失败, 权限不足";
                    }
                }
                else
                {
                    m_value = "要删除的文件不存在";
                }
            }
            else if (delType == "folder")
            {
                if (Directory.Exists(delName))
                {
                    try
                    {
                        Directory.Delete(delName, true);
                        this.m_value = "删除目录成功, 被删除的目录为: " + Path.GetFileName(delName);
                    }
                    catch
                    {
                        this.m_value = "删除目录失败, 权限不足";
                    }
                }
                else
                {
                    this.m_value = "要删除的目录不存在";
                }
            }
        }

        /// <summary>
        /// 上传文件
        /// </summary>
        private void UploadFile()
        {
            HttpRequest Request = HttpContext.Current.Request;
            HttpPostedFile fileUpload = Request.Files["fileUpload"];

            string serverPath = TextUtility.GetRealPath(m_folderPath);

            if (fileUpload.ContentLength == 0)
            {
                m_value = "请先选择文件";
            }
            else if (fileUpload.ContentLength > 4096000)
            {
                m_value = "文件过大，无法进行上传";
            }
            else if (fileUpload.ContentType.ToUpper().IndexOf("IMAGE") == -1)
            {
                m_value = "请选择图片文件";
            }
            else
            {
                // HttpContext.Current.Server.ScriptTimeout = 600;
                string fileName = Path.GetFileName(fileUpload.FileName);

                if (File.Exists(serverPath + "\\" + fileName))
                {
                    Random rnd = new Random();
                    string newFileName = Path.GetFileNameWithoutExtension(fileName) + "_" + rnd.Next(1, 1000) + Path.GetExtension(fileName);

                    try
                    {
                        fileUpload.SaveAs(serverPath + "\\" + newFileName);
                        m_value = "上传的文件名已存在, 自动重命名为: " + newFileName;
                        m_uploadFilePath = TextUtility.AddLast(m_folderPath, "/") + newFileName;
                    }
                    catch
                    {
                        m_value = "写入文件失败, 权限不足";
                    }
                }
                else
                {
                    try
                    {
                        fileUpload.SaveAs(serverPath + "\\" + fileName);
                        m_value = "上传文件完毕, 文件名为: " + fileName;
                        m_uploadFilePath = TextUtility.AddLast(m_folderPath, "/") + fileName;
                    }
                    catch
                    {
                        m_value = "写入文件失败, 权限不足";
                    }
                }
            }
        }

        #endregion









        /// <summary>
        /// 将转换成二进制码的图片保存到数据库中
        /// </summary>
        private void UploadFileToByte()
        {
            HttpRequest Request = HttpContext.Current.Request;
            HttpPostedFile fileUpload = Request.Files["fileUpload"];

            string serverPath = TextUtility.GetRealPath(m_folderPath);

            if (fileUpload.ContentLength == 0)
            {
                m_value = "请先选择文件";
            }
            else if (fileUpload.ContentLength > 4096000)
            {
                m_value = "文件过大，无法进行上传";
            }
            else if (fileUpload.ContentType.ToUpper().IndexOf("IMAGE") == -1)
            {
                m_value = "请选择图片文件";
            }
            else
            {
                // HttpContext.Current.Server.ScriptTimeout = 600;
                string fileName = Path.GetFileName(fileUpload.FileName);

                if (File.Exists(serverPath + "\\" + fileName))
                {
                    Random rnd = new Random();
                    string newFileName = Path.GetFileNameWithoutExtension(fileName) + "_" + rnd.Next(1, 1000) + Path.GetExtension(fileName);

                    try
                    {
                        fileUpload.SaveAs(serverPath + "\\" + newFileName);
                        m_value = "上传的文件名已存在, 自动重命名为: " + newFileName;


                        m_uploadFilePath = FileToBinary(serverPath + "\\" + newFileName);


                    }
                    catch (Exception ex)
                    {
                        
                        m_value = "写入文件失败, 权限不足";
                        throw ex;
                    }
                }
                else
                {
                    try
                    {
                        fileUpload.SaveAs(serverPath + "\\" + fileName);
                        m_value = "上传文件完毕, 文件名为: " + fileName;

                       // m_uploadFilePath = TextUtility.AddLast(m_folderPath, "/") + fileName;

                        m_uploadFilePath = FileToBinary(serverPath + "\\" + fileName);
                    }
                    catch (Exception ex)
                    {
                        m_value = "写入文件失败, 权限不足";
                        throw ex;
                    }
                }
            }
        }





        /// <summary>
        /// 将传进来的文件转换成字符串（二进制）
        /// </summary>
        /// <param name=" FilePath">待处理的文件路径</param>
        /// <returns>String</returns>
        public string FileToBinary(string FilePath)
        {
            FileStream fs = new FileStream(FilePath, FileMode.Open, FileAccess.Read);
            //利用新传来的路径实例化一个FileStream对象
            int filelength = Convert.ToInt32(fs.Length);
            //得到对象的大小
            Byte[] filebyteArray = new byte[filelength];
            //申明一个byte数组
            BinaryReader br = new BinaryReader(fs);
            //申明一个读取二进制流的BinaryReader对象
            for (int i = 0; i < filelength; i++)
            {   //循环数组大小那么多次
                br.Read(filebyteArray, 0, filelength); //第一个数组用0表示
                //将数据读取出来放在数组中
            }

            string strData = Convert.ToBase64String(filebyteArray);  //8位无符号整数数组ToBase64
            //将数组转换为String字符传
            return strData;
        }




    }


    

    /// <summary>
    /// 自定义排序
    /// </summary>
    public class FilesComparer : IComparer<HttpFolderInfo>
    {
        private string _sortColumn;

        /// <summary>
        /// 构造方法
        /// </summary>
        /// <param name="sortExpression">要排序的字段</param>
        public FilesComparer(string sortExpression)
        {
            this._sortColumn = sortExpression;
        }

        /// <summary>
        /// 实现接口定义的 Compare 方法，比较两个 FolderInfo 对象实例
        /// </summary>
        /// <param name="a">实体类</param>
        /// <param name="b"></param>
        /// <returns>实体类</returns>
        public int Compare(HttpFolderInfo a, HttpFolderInfo b)
        {
            int retVal = 0;
            switch (_sortColumn.ToLower())
            {
                case "name":
                    retVal = String.Compare(a.Name, b.Name, StringComparison.InvariantCultureIgnoreCase);
                    break;
                case "ext":
                    retVal = String.Compare(a.ExtName, b.ExtName, StringComparison.InvariantCultureIgnoreCase);
                    break;
                case "size":
                    retVal = String.Compare(a.FormatSize, b.FormatSize, StringComparison.InvariantCultureIgnoreCase);
                    break;
                case "modifydate":
                    retVal = DateTime.Compare(DateTime.Parse(a.FormatModifyDate), DateTime.Parse(b.FormatModifyDate));
                    break;
                default:
                    retVal = String.Compare(a.Name, b.Name, StringComparison.InvariantCultureIgnoreCase);
                    break;
            }
            return (retVal);
        }
    }
}
