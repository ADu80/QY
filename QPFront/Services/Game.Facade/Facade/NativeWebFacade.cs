using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Game.Data.Factory;
using Game.IData;
using Game.Kernel;
using Game.Utils;
using Game.Entity.NativeWeb;
using System.Data;

namespace Game.Facade
{
    /// <summary>
    /// 网站外观
    /// </summary>
    public class NativeWebFacade
    {
        #region Fields

        private INativeWebDataProvider aideNativeWebDataProvider;
        #endregion
        //public NativeWebFacade()
        //{
        //    string id = Request.GetQueryString("CommandName");
        //}

        #region 构造函数

        /// <summary>
        /// 构造函数
        /// </summary>
        public NativeWebFacade()
        {
            aideNativeWebDataProvider = ClassFactory.GetINativeWebDataProvider();
        }
        #endregion

        #region 网站新闻

        /// <summary>
        /// 获取置顶新闻列表
        /// </summary>
        /// <param name="newsType"></param>
        /// <param name="hot"></param>
        /// <param name="elite"></param>
        /// <param name="top"></param>
        /// <returns></returns>
        public IList<News> GetTopNewsList(int typeID, int hot, int elite, int top)
        {
            return aideNativeWebDataProvider.GetTopNewsList(typeID, hot, elite, top);
        }

        /// <summary>
        /// 获取新闻列表
        /// </summary>
        /// <returns></returns>
        public IList<News> GetNewsList()
        {
            return aideNativeWebDataProvider.GetNewsList();
        }

        /// <summary>
        /// 获取分页新闻列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public PagerSet GetNewsList(int pageIndex, int pageSize)
        {
            return aideNativeWebDataProvider.GetNewsList(pageIndex, pageSize);
        }

        /// <summary>
        /// 获取新闻 by newsID
        /// </summary>
        /// <param name="newsID"></param>
        /// <param name="mode">模式选择, 0=当前主题, 1=上一主题, 2=下一主题</param>
        /// <returns></returns>
        public News GetNewsByNewsID(int newsID, byte mode)
        {
            return aideNativeWebDataProvider.GetNewsByNewsID(newsID, mode);
        }

        /// <summary>
        /// 获取公告
        /// </summary>
        /// <param name="noticeID"></param>
        /// <returns></returns>
        public Notice GetNotice(int noticeID)
        {
            return aideNativeWebDataProvider.GetNotice(noticeID);
        }

        #endregion

        #region 网站问题

        /// <summary>
        /// 获取问题列表
        /// </summary>
        /// <param name="issueType"></param>
        /// <param name="top"></param>
        /// <returns></returns>
        public IList<GameIssueInfo> GetTopIssueList(int top)
        {
            return aideNativeWebDataProvider.GetTopIssueList(top);
        }

        /// <summary>
        /// 获取问题列表
        /// </summary>
        /// <returns></returns>
        public IList<GameIssueInfo> GetIssueList()
        {
            return aideNativeWebDataProvider.GetIssueList();
        }

        /// <summary>
        /// 获取分页问题列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public PagerSet GetIssueList(int pageIndex, int pageSize)
        {
            return aideNativeWebDataProvider.GetIssueList(pageIndex, pageSize);
        }

        /// <summary>
        /// 获取问题实体
        /// </summary>
        /// <param name="issueID"></param>
        /// <param name="mode">模式选择, 0=当前主题, 1=上一主题, 2=下一主题</param>
        /// <returns></returns>
        public GameIssueInfo GetIssueByIssueID(int issueID, byte mode)
        {
            return aideNativeWebDataProvider.GetIssueByIssueID(issueID, mode);
        }
        #endregion

        #region 反馈意见

        /// <summary>
        /// 获取分页反馈意见列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public PagerSet GetFeedbacklist(int pageIndex, int pageSize)
        {
            return aideNativeWebDataProvider.GetFeedbacklist(pageIndex, pageSize);
        }

        /// <summary>
        /// 获取反馈意见实体
        /// </summary>
        /// <param name="issueID"></param>
        /// <param name="mode">模式选择, 0=当前主题, 1=上一主题, 2=下一主题</param>
        /// <returns></returns>
        public GameFeedbackInfo GetGameFeedBackInfo(int feedID, byte mode)
        {
            return aideNativeWebDataProvider.GetGameFeedBackInfo(feedID, mode);
        }

        /// <summary>
        /// 更新浏览量
        /// </summary>
        /// <param name="feedID"></param>
        public void UpdateFeedbackViewCount(int feedID)
        {
            aideNativeWebDataProvider.UpdateFeedbackViewCount(feedID);
        }

        /// <summary>
        /// 发表留言
        /// </summary>
        /// <returns></returns>
        public Message PublishFeedback(GameFeedbackInfo info)
        {
            return aideNativeWebDataProvider.PublishFeedback(info);
        }

        #endregion

        #region 游戏帮助数据

        /// <summary>
        /// 获取推荐游戏详细列表
        /// </summary>
        /// <returns></returns>
        public IList<GameRulesInfo> GetGameHelps(int top)
        {
            return aideNativeWebDataProvider.GetGameHelps(top);
        }

        /// <summary>
        /// 获取游戏详细信息
        /// </summary>
        /// <param name="kindID"></param>
        /// <returns></returns>
        public GameRulesInfo GetGameHelp(int kindID)
        {
            return aideNativeWebDataProvider.GetGameHelp(kindID);
        }

        #endregion

        #region 游戏比赛信息

        /// <summary>
        /// 得到比赛列表
        /// </summary>
        /// <returns></returns>
        public IList<GameMatchInfo> GetMatchList()
        {
            return aideNativeWebDataProvider.GetMatchList();
        }

        /// <summary>
        /// 得到比赛详细信息
        /// </summary>
        /// <param name="matchID"></param>
        /// <returns></returns>
        public GameMatchInfo GetMatchInfo(int matchID)
        {
            return aideNativeWebDataProvider.GetMatchInfo(matchID);
        }

        /// <summary>
        /// 比赛报名
        /// </summary>
        /// <param name="userInfo"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public Message AddGameMatch(GameMatchUserInfo userInfo, string password)
        {
            return aideNativeWebDataProvider.AddGameMatch(userInfo, password);
        }

        #endregion

        #region 新闻
        /// <summary>
        /// 获取新闻标题时间是否最新最热
        /// </summary>
        /// <returns></returns>
        /// 
        public DataTable GetHotNewList(int NewsID, string Subject, int IsHot, int ClassID, string IssueDate)
        {
            return aideNativeWebDataProvider.GetHotNewList(NewsID, Subject, IsHot, ClassID, IssueDate);
        }
        /// <summary>
        /// 获取新闻公告类型名称时间
        /// </summary>
        /// <param name="Subject"></param>
        /// <param name="ClassID"></param>
        /// <param name="IssueDate"></param>
        /// <returns></returns>

        public DataTable GetNewTypeList(int NewsID, string Subject, int ClassID, string IssueDate)
        {
            return aideNativeWebDataProvider.GetNewTypeList(NewsID, Subject, ClassID, IssueDate);
        }
        /// <summary>
        /// 获取新闻标题时间作者正文
        /// </summary>
        /// <param name="Subject"></param>
        /// <param name="UserID"></param>
        /// <param name="IssueDate"></param>
        /// <param name="Body"></param> 
        /// <returns></returns>
        public DataTable GetNewDetailList(int id)
        {
            return aideNativeWebDataProvider.GetNewDetailList(id);
        }
        #endregion


        #region 客服在线
        /// <summary>
        /// 游戏反馈
        /// </summary>
        /// <param name="FeedbackID"></param>
        /// <param name="Accounts"></param>
        /// <param name="FeedbackContent"></param>
        /// <returns></returns>
        public DataTable GetFeedbackList(int FeedbackID, string Accounts, string FeedbackContent)
        {
            return aideNativeWebDataProvider.GetFeedbackList(FeedbackID, Accounts, FeedbackContent);
        }

        /// <summary>
        ///  游戏建议
        /// </summary>
        /// <returns></returns>
        public Message InsertGameFeedbackadvise(GameFeedbackInfo info)
        {
            return aideNativeWebDataProvider.InsertGameFeedbackadvise(info);
        }
        /// <summary>
        /// 游戏bug反馈
        /// </summary>
        /// <param name="info"></param>
        /// <returns></returns>
        public Message InsertGameFeedback(GameFeedbackInfo info)
        {
            return aideNativeWebDataProvider.InsertGameFeedback(info);
        }
        /// <summary>
        /// 游戏bug反馈
        /// </summary>
        /// <param name="info"></param>
        /// <returns></returns>
        public Message InsertGameFeedback(int ftype, GameFeedbackInfo info)
        {
            return aideNativeWebDataProvider.InsertGameFeedback(ftype, info);
        }
        /// <summary>
        /// 常见问题
        /// </summary>
        /// <param name="FeedbackID"></param>
        /// <param name="Accounts"></param>
        /// <param name="FeedbackContent"></param>
        /// <returns></returns>
        public DataTable GetGameIssueInfoList(int IssueID, string IssueTitle, string IssueContent, int Nullity, string CollectDate, string ModifyDate)
        {
            return aideNativeWebDataProvider.GetGameIssueInfoList(IssueID, IssueTitle, IssueContent, Nullity, CollectDate, ModifyDate);
        }

        public Message InsertGameIssueInfo(GameIssueInfo info)
        {
            return aideNativeWebDataProvider.InsertGameIssueInfo(info);
        }
        #endregion
    }
}
