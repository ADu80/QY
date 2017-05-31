using Game.Facade;
using QPFront.Controller.Helpers;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Web;

namespace QPFront.Controller
{
    public abstract class ControllerBase
    {
        public AccountsFacade aideAccountFacade = new AccountsFacade();
        public RecordFacade aideRecordFacade = new RecordFacade();
        public NativeWebFacade aideNativeWebFacade = new NativeWebFacade();
        public PlatformFacade aidePlatformFacade = new PlatformFacade();
        public PlatformManagerFacade aidePlatformManagerFacade = new PlatformManagerFacade();
        public TreasureFacade aideTreasureFacade = new TreasureFacade();
        protected string GetJsonByDataTable2(DataTable dt)
        {
            string strcol = "";
            string strrow = "";
            foreach (DataRow dr in dt.Rows)
            {
                strcol = "\"checked\":false,\"selected\":false,";
                foreach (DataColumn dc in dt.Columns)
                {
                    if (dc.ColumnName == "OrderDetails")
                    {
                        strcol += "\"" + dc.ColumnName + "\":" + dr[dc.ColumnName].ToString() + ",";
                    }
                    else
                    {
                        strcol += "\"" + dc.ColumnName + "\":\"" + dr[dc.ColumnName].ToString() + "\",";
                    }
                }
                strrow += "{" + strcol.Trim().Trim(',') + "},";
            }
            string json = "[" + strrow.Trim().Trim(',') + "]";
            return JsonReplace(json);
        }
        protected string GetJsonByDataTable(DataTable dt, string detailName)
        {
            string strcol = "";
            string strrow = "";
            foreach (DataRow dr in dt.Rows)
            {
                strcol = "\"checked\":false,\"selected\":false,";
                foreach (DataColumn dc in dt.Columns)
                {
                    if (dc.ColumnName == detailName)
                    {
                        strcol += "\"" + dc.ColumnName + "\":" + dr[dc.ColumnName].ToString() + ",";
                    }
                    else
                    {
                        strcol += "\"" + dc.ColumnName + "\":\"" + dr[dc.ColumnName].ToString() + "\",";
                    }
                }
                strrow += "{" + strcol.Trim().Trim(',') + "},";
            }
            string json = "[" + strrow.Trim().Trim(',') + "]";
            return JsonReplace(json);
        }

        protected string GetJsonByDataTable(DataTable dt)
        {
            string strcol = "";
            string strrow = "";
            foreach (DataRow dr in dt.Rows)
            {
                strcol = "\"checked\":false,\"selected\":false,";
                foreach (DataColumn dc in dt.Columns)
                {
                    strcol += "\"" + dc.ColumnName + "\":\"" + dr[dc.ColumnName].ToString() + "\",";
                }
                strrow += "{" + strcol.Trim().Trim(',') + "},";
            }
            string json = "[" + strrow.Trim().Trim(',') + "]";
            return JsonReplace(json);
        }

        protected string GetJsonByDataSet(DataSet ds)
        {
            string json = "{";
            foreach (DataTable dt in ds.Tables)
            {
                string strcol = "";
                string strrow = "";
                foreach (DataRow dr in dt.Rows)
                {
                    strcol = "";
                    foreach (DataColumn dc in dt.Columns)
                    {
                        strcol += "\"" + dc.ColumnName + "\":\"" + dr[dc.ColumnName].ToString() + "\",";
                    }
                    strrow += "{" + strcol.Trim().Trim(',') + "},";
                }
                json += "\"" + dt.TableName + "\":[" + strrow.Trim().Trim(',') + "],";
            }
            return JsonReplace(json.Trim().Trim(',') + "}");
        }

        protected string GetJsonByObjectList<T>(T t)
        {
            DataContractJsonSerializer json = new DataContractJsonSerializer(t.GetType());
            string szJson = "";
            //序列化
            using (MemoryStream stream = new MemoryStream())
            {
                json.WriteObject(stream, t);
                szJson = Encoding.UTF8.GetString(stream.ToArray());
            }
            return szJson;
        }

        protected void WriteLog(string module, string log)
        {
            LogHelper.WriteLog(module, log);
        }

        protected string ImgToBase64String(string Imagefilename)
        {
            try
            {
                Bitmap bmp = new Bitmap(Imagefilename);
                FileStream fs = new FileStream(Imagefilename + ".txt", FileMode.Create);
                StreamWriter sw = new StreamWriter(fs);

                MemoryStream ms = new MemoryStream();
                bmp.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
                byte[] arr = new byte[ms.Length];
                ms.Position = 0;
                ms.Read(arr, 0, (int)ms.Length);
                ms.Close();
                string strbaser64 = Convert.ToBase64String(arr);
                sw.Write(strbaser64);
                sw.Close();
                fs.Close();
                return "data:image/png;base64," + strbaser64;
                // MessageBox.Show("转换成功!");
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        protected string GetCorrectJson(string json)
        {
            return json.Replace("\n", "").Replace("\r", "");
        }

        protected string JsonReplace(string json)
        {
            return json.Replace("\n", "")
                .Replace("\r", "")
                .Replace("\t", "");
        }

        protected string GetClientIP()
        {
            return "";
        }
    }
}
