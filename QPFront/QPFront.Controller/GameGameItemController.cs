using QPFront.Helpers;
using System;
using System.Data;
using System.Web;

namespace QPFront.Controller
{
    public class GameGameItemController : ControllerBase, IController
    {
        public string Index(HttpRequest req)
        {
            return "";
        }
        public string Add(HttpRequest req)
        {
            return "";
        }

        public string Delete(HttpRequest req)
        {
            return "";
        }

        public string Update(HttpRequest req)
        {
            return "";
        }
        public string HotGameList(HttpRequest req)
        {
            try
            {
                object oGameID = req["gameId"];
                object oGameName = req["gameName"];
                object oImgUrl = req["imgUrl"];
                int GameID = Convert.ToInt32(oGameID ?? 0);
                string GameName = "";
                string ImgUrl = "";
                DataTable dt = aidePlatformFacade.GetHotGameList(GameID, GameName, ImgUrl);
                //DealImg(dt);
                string json = GetJsonByDataTable(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }

            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        //private void DealImg(DataTable dt)
        //{
        //    foreach(DataRow dr in dt.Rows)
        //    {
        //        string imgurl = dr["ImgUrl"].ToString();
        //        string base64str = ImgToBase64String(imgurl);
        //        dr["ImgUrl"] = base64str;
        //    }
        //    dt.AcceptChanges();
        //}

        public string GetDownload(HttpRequest req)
        {
            try
            {

                int GameID = Convert.ToInt32(req.Form["gameId"] ?? "0");
                string GameName = req.Form["gameName"];
                DataTable dt = aidePlatformFacade.GetDownload(GameID, GameName);

                string json = GetJsonByDataTable(dt);
                json = GetCorrectJson(json);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }
    }
}
