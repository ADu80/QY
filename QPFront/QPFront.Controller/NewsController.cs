using Game.Entity.NativeWeb;
using Game.Kernel;
using QPFront.Helpers;
using System;
using System.Data;
using System.Web;

namespace QPFront.Controller
{
    public class NewsController : ControllerBase, IController
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
        /// <summary>
        ///  获取新闻标题时间是否最新最热
        /// </summary>
        /// <param name="req"></param>
        /// <returns></returns>
        public string HotNewList(HttpRequest req)
        {
            try
            {
                int NewsID = Convert.ToInt32(req.Form["newsID"] ?? "-1");
                string Subject = req.Form["subject"];
                int IsHot = Convert.ToInt32(req.Form["isHot"] ?? "0");
                int ClassID = Convert.ToInt32(req.Form["classID"]);
                string IssueDate = req.Form["issueDate"];
                DataTable dt = aideNativeWebFacade.GetHotNewList(NewsID, Subject, IsHot, ClassID, IssueDate);

                string json = GetJsonByDataTable(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }
        /// <summary>
        ///  获取新闻公告类型名称时间
        /// </summary>
        /// <param name="req"></param>
        /// <returns></returns>
        public string NewTypeList(HttpRequest req)
        {
            try
            {
                object oNewsID = req.Form["newsID"];
                object oSubject = req.Form["subject"];
                object oClassID = req.Form["classID"];
                object oIssueDate = req.Form["issueDate"];
                int NewsID = 0;
                string Subject = "";
                int ClassID = 0;
                string IssueDate = "";
                DataTable dt = aideNativeWebFacade.GetNewTypeList(NewsID, Subject, ClassID, IssueDate);
                string json = GetJsonByDataTable(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }
        /// <summary>
        /// 获取新闻标题时间作者正文
        /// </summary>
        /// <param name="req"></param>
        /// <returns></returns>
        public string NewDetailList(HttpRequest req)
        {
            try
            {
                int id = Convert.ToInt32(req["id"] ?? "0");
                DataTable dt = aideNativeWebFacade.GetNewDetailList(id);
                string json = GetJsonByDataTable(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }
        /// <summary>
        /// 游戏反馈
        /// </summary>
        /// <param name="req"></param>
        /// <returns></returns>
        public string FeedbackList(HttpRequest req)
        {
            try
            {
                int FeedbackID = Convert.ToInt32(req["feedbackID"] ?? "0");
                string Accounts = req["accounts"];
                string FeedbackContent = req["feedbackContent"];


                DataTable dt = aideNativeWebFacade.GetFeedbackList(FeedbackID, Accounts, FeedbackContent);
                string json = GetJsonByDataTable(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        enum GameFeedbackType
        {
            Feedback = 1,
            Advice = 2,
            Bug = 3
        }

        /// <summary>
        /// 游戏反馈
        /// </summary>
        /// <param name="req"></param>
        /// <returns></returns>
        public string AddFeedback(HttpRequest req)
        {
            try
            {
                int ftype = Convert.ToInt32(req["ftype"] ?? "0");
                GameFeedbackInfo info = new GameFeedbackInfo();
                info.Accounts = req.Form["accounts"];
                info.FeedbackTitle = req.Form["title"];
                info.Phone = req.Form["phone"];
                info.FeedbackContent = req.Form["content"];
                info.ClientIP = req.Form["client_ip"];
                info.EMail = req.Form["email"];
                info.QQ = req["qq"];
                return AddFeedback(ftype, info);
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        string AddFeedback(int ftype, GameFeedbackInfo info)
        {
            Message msg = aideNativeWebFacade.InsertGameFeedback(ftype, info);

            if (msg.Success)
            {
                return JsonResultHelper.GetSuccessJson("保存成功");
            }
            return JsonResultHelper.GetErrorJson(msg.Content);
        }

        public string GameIssueInfoList(HttpRequest req)
        {
            try
            {
                object oIssueID = req.Form["issueID"];
                object oIssueTitle = req.Form["issueTitle"];
                object oIssueContent = req.Form["issueContent"];
                object oNullity = req.Form["nullity"];
                object oCollectDate = req.Form["collectDate"];
                object oModifyDate = req.Form["modifyDate"];
                int IssueID = 0;
                string IssueTitle = "";
                string IssueContent = "";
                int Nullity = 0;
                string CollectDate = "";
                string ModifyDate = "";
                DataTable dt = aideNativeWebFacade.GetGameIssueInfoList(IssueID, IssueTitle, IssueContent, Nullity, CollectDate, ModifyDate);
                string json = GetJsonByDataTable(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        /// <summary>
        /// 新增问题
        /// </summary>
        /// <param name="gameIssue"></param>
        public string AddGameIssue(HttpRequest req)
        {
            GameIssueInfo info = new GameIssueInfo();
            string content = req["issueContent"];
            info.IssueTitle = content.Length > 20 ? content.Substring(0, 20) + "..." : content;
            info.IssueContent = req["issueContent"];
            info.QQ = req["qq"];
            info.Nullity = 0;
            info.CollectDate = DateTime.Now;
            info.ModifyDate = DateTime.Now;
            try
            {
                aideNativeWebFacade.InsertGameIssueInfo(info);
                return JsonResultHelper.GetSuccessJson("保存成功！");
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message);
            }
        }
    }
}
