using System.Collections.Generic;

using Game.Kernel;
using System.Data;
using Game.Entity.NativeWeb;

namespace Game.IData
{
    /// <summary>
    /// 网站库数据层接口
    /// </summary>
    public interface INativeWebDataProvider //: IProvider
    {
        #region 网站新闻

        /// <summary>
        /// 获取置顶新闻列表
        /// </summary>
        /// <param name="newsType"></param>
        /// <param name="hot"></param>
        /// <param name="elite"></param>
        /// <param name="top"></param>
        /// <returns></returns>
        IList<News> GetTopNewsList(int typeID, int hot, int elite, int top);

        /// <summary>
        /// 获取新闻列表
        /// </summary>
        /// <returns></returns>
        IList<News> GetNewsList();

        /// <summary>
        /// 获取分页新闻列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        PagerSet GetNewsList(int pageIndex, int pageSize);

        /// <summary>
        /// 获取新闻 by newsID
        /// </summary>
        /// <param name="newsID"></param>
        /// <param name="mode">模式选择, 0=当前主题, 1=上一主题, 2=下一主题</param>
        /// <returns></returns>
        News GetNewsByNewsID(int newsID, byte mode);

        /// <summary>
        /// 获取公告
        /// </summary>
        /// <param name="noticeID"></param>
        /// <returns></returns>
        Notice GetNotice(int noticeID);

        #endregion

        #region 网站问题

        /// <summary>
        /// 获取问题列表
        /// </summary>
        /// <param name="issueType"></param>
        /// <param name="top"></param>
        /// <returns></returns>
        IList<GameIssueInfo> GetTopIssueList(int top);

        /// <summary>
        /// 获取问题列表
        /// </summary>
        /// <returns></returns>
        IList<GameIssueInfo> GetIssueList();

        /// <summary>
        /// 获取分页问题列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        PagerSet GetIssueList(int pageIndex, int pageSize);

        /// <summary>
        /// 获取问题实体
        /// </summary>
        /// <param name="issueID"></param>
        /// <param name="mode">模式选择, 0=当前主题, 1=上一主题, 2=下一主题</param>
        /// <returns></returns>
        GameIssueInfo GetIssueByIssueID(int issueID, byte mode);

        #endregion

        #region 反馈意见

        /// <summary>
        /// 获取分页反馈意见列表
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        PagerSet GetFeedbacklist(int pageIndex, int pageSize);

        /// <summary>
        /// 获取反馈意见实体
        /// </summary>
        /// <param name="issueID"></param>
        /// <param name="mode">模式选择, 0=当前主题, 1=上一主题, 2=下一主题</param>
        /// <returns></returns>
        GameFeedbackInfo GetGameFeedBackInfo(int feedID, byte mode);

        /// <summary>
        /// 更新浏览量
        /// </summary>
        /// <param name="feedID"></param>
        void UpdateFeedbackViewCount(int feedID);

        /// <summary>
        /// 发表留言
        /// </summary>
        /// <returns></returns>
        Message PublishFeedback(GameFeedbackInfo info);

        #endregion

        #region 游戏帮助数据

        /// <summary>
        /// 获取推荐游戏详细列表
        /// </summary>
        /// <returns></returns>
        IList<GameRulesInfo> GetGameHelps(int top);

        /// <summary>
        /// 获取游戏详细信息
        /// </summary>
        /// <param name="kindID"></param>
        /// <returns></returns>
        GameRulesInfo GetGameHelp(int kindID);

        #endregion

        #region 游戏比赛信息

        /// <summary>
        /// 得到比赛列表
        /// </summary>
        /// <returns></returns>
        IList<GameMatchInfo> GetMatchList();

        /// <summary>
        /// 得到比赛详细信息
        /// </summary>
        /// <param name="matchID"></param>
        /// <returns></returns>
        GameMatchInfo GetMatchInfo(int matchID);

        /// <summary>
        /// 比赛报名
        /// </summary>
        /// <param name="userInfo"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        Message AddGameMatch(GameMatchUserInfo userInfo, string password);

        #endregion


        #region 新闻
        /// <summary>
        ///活动公告：获取新闻标题时间是否最热
        /// </summary>
        /// <param name="Subject"></param>
        /// <param name="IsHot"></param>
        /// <param name="IssueDate"></param>
        /// <returns></returns>
        /// 
        DataTable GetHotNewList(int NewsID, string Subject, int IsHot, int ClassID, string IssueDate);
        //IList<News> GetHotNewList(string Subject, int IsHot, string IssueDate);
        /// <summary>
        ///新闻公告： 获取新闻公告类型名称时间
        /// </summary>
        /// <param name="Subject"></param>
        /// <param name="ClassID"></param>
        /// <param name="IssueDate"></param>
        /// <returns></returns>
        DataTable GetNewTypeList(int NewsID, string Subject, int ClassID, string IssueDate);

        /// <summary>
        /// 新闻详情：标题时间作者正文
        /// </summary>
        /// <param name="Subject"></param>
        /// <param name="UserID"></param>
        /// <param name="IssueDate"></param>
        /// <param name="Body"></param>
        /// <returns></returns>
        DataTable GetNewDetailList(int id);
        #endregion

        #region 客服在线
        /// <summary>
        /// 游戏反馈
        /// </summary>
        /// <param name="FeedbackID"></param>
        /// <param name="Accounts"></param>
        /// <param name="FeedbackContent"></param>
        /// <returns></returns>
        DataTable GetFeedbackList(int FeedbackID, string Accounts, string FeedbackContent);
        /// <summary>
        /// 游戏建议
        /// </summary>
        /// <param name="GameFeedbackInfo"></param>
        /// <returns></returns>
        /// 
        Message InsertGameFeedbackadvise(GameFeedbackInfo info);
        /// <summary>
        /// 游戏bug
        /// </summary>
        /// <param name="info"></param>
        /// <returns></returns>
        Message InsertGameFeedback(GameFeedbackInfo info);
        Message InsertGameFeedback(int ftype, GameFeedbackInfo info);
        /// <summary>
        /// 常见问题
        /// </summary>
        /// <param name="IssueID"></param>
        /// <param name="IssueTitle"></param>
        /// <param name="IssueContent"></param>
        /// <param name="Nullity"></param>
        /// <param name="CollectDate"></param>
        /// <param name="ModifyDate"></param>
        /// <returns></returns>
        DataTable GetGameIssueInfoList(int IssueID, string IssueTitle, string IssueContent, int Nullity, string CollectDate, string ModifyDate);
        Message InsertGameIssueInfo(GameIssueInfo info);
        #endregion
    }
}
