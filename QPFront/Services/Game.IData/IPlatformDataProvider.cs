using System.Collections.Generic;
using System.Data;
using Game.Entity.Platform;
using Game.Kernel;

namespace Game.IData
{
    /// <summary>
    /// 平台库数据层接口
    /// </summary>
    public interface IPlatformDataProvider //: IProvider
    {
        /// <summary>
        /// 根据服务器地址获取数据库信息
        /// </summary>
        /// <param name="addrString"></param>
        /// <returns></returns>
        DataBaseInfo GetDatabaseInfo(string addrString);

        /// <summary>
        /// 根据游戏ID获取服务器地址信息
        /// </summary>
        /// <param name="kindID"></param>
        /// <returns></returns>
        GameGameItem GetDBAddString(int kindID);

        /// <summary>
        /// 获取游戏类型列表
        /// </summary>
        /// <returns></returns>
        IList<GameTypeItem> GetGmaeTypes();

        /// <summary>
        /// 根据类型ID获取游戏列表
        /// </summary>
        /// <param name="typeID"></param>
        /// <returns></returns>
        IList<GameKindItem> GetGameKindsByTypeID(int typeID);

        /// <summary>
        /// 得到所有的游戏
        /// </summary>
        /// <returns></returns>
        IList<GameKindItem> GetAllKinds();

        /// <summary>
        /// 得到积分的游戏
        /// </summary>
        /// <returns></returns>
        IList<GameKindItem> GetIntegralKinds( );

        /// <summary>
        /// 得到游戏列表
        /// </summary>
        /// <returns></returns>
        IList<GameGameItem> GetGameList();

        #region 公共

        /// <summary>
        /// 根据SQL语句查询一个值
        /// </summary>
        /// <param name="sqlQuery"></param>
        /// <returns></returns>
        object GetObjectBySql( string sqlQuery );

        /// <summary>
        /// 根据sql获取实体
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="commandText"></param>
        /// <returns></returns>
        T GetEntity<T>( string commandText );

        #endregion

        #region 游戏
        /// <summary>
        /// 获取游戏图标名称
        /// </summary>
        /// <param name="GameName"></param>
        /// <param name="ImgUrl"></param>
        /// <returns></returns>
        DataTable GetHotGameList(int GameID, string GameName, string ImgUrl);
        /// <summary>
        /// 下载中心
        /// </summary>
        /// <param name="GameID"></param>
        /// <param name="GameDes"></param>
        /// <param name="DownLoadAddr"></param>
        /// <param name="ORCodeAddr"></param>
        /// <returns></returns>
        DataTable GetDownload(int GameID,string GameName);

        //DataTable GetRank(int GameID,string GameName, string GameStar, string DownloadCount);

        #endregion


        DataTable GetShopProperty();
         

    }
}
