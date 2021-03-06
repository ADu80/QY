﻿using System.Collections.Generic;

using Game.Data.Factory;
using Game.IData;
using Game.Entity.Platform;
using System.Data;

namespace Game.Facade
{
    /// <summary>
    /// 平台外观
    /// </summary>
    public class PlatformFacade
    {
        #region Fields

        private IPlatformDataProvider platformData;

        #endregion

        #region 构造函数

        /// <summary>
        /// 构造函数
        /// </summary>
        public PlatformFacade()
        {
            platformData = ClassFactory.GetIPlatformDataProvider();
        }
        #endregion

        /// <summary>
        /// 根据服务器地址获取数据库信息
        /// </summary>
        /// <param name="addrString"></param>
        /// <returns></returns>
        public DataBaseInfo GetDatabaseInfo(string addrString)
        {
            return platformData.GetDatabaseInfo(addrString);
        }

        /// <summary>
        /// 根据游戏ID获取服务器地址信息
        /// </summary>
        /// <param name="kindID"></param>
        /// <returns></returns>
        public GameGameItem GetDBAddString(int kindID)
        {
            return platformData.GetDBAddString(kindID);
        }

        /// <summary>
        /// 获取游戏类型列表
        /// </summary>
        /// <returns></returns>
        public IList<GameTypeItem> GetGmaeTypes()
        {
            return platformData.GetGmaeTypes();
        }

        /// <summary>
        /// 根据类型ID获取游戏列表
        /// </summary>
        /// <param name="typeID"></param>
        /// <returns></returns>
        public IList<GameKindItem> GetGameKindsByTypeID(int typeID)
        {
            return platformData.GetGameKindsByTypeID(typeID);
        }

        /// <summary>
        /// 得到所有的游戏
        /// </summary>
        /// <returns></returns>
        public IList<GameKindItem> GetAllKinds()
        {
            return platformData.GetAllKinds();
        }

        /// <summary>
        /// 得到所有的游戏
        /// </summary>
        /// <returns></returns>
        public IList<GameKindItem> GetIntegralKinds()
        {
            return platformData.GetIntegralKinds();
        }

        /// <summary>
        /// 得到游戏列表
        /// </summary>
        /// <returns></returns>
        public IList<GameGameItem> GetGameList()
        {
            return platformData.GetGameList();
        }

        #region 公共

        /// <summary>
        /// 根据SQL语句查询一个值
        /// </summary>
        /// <param name="sqlQuery"></param>
        /// <returns></returns>
        public object GetObjectBySql(string sqlQuery)
        {
            return platformData.GetObjectBySql(sqlQuery);
        }

        /// <summary>
        /// 根据sql获取实体
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="commandText"></param>
        /// <returns></returns>
        public T GetEntity<T>(string commandText)
        {
            return platformData.GetEntity<T>(commandText);
        }

        #endregion

        /// <summary>
        /// 获取游戏图标名称
        /// </summary>
        /// <param name="GameName"></param>
        /// <param name="ImgUrl"></param>
        /// <returns></returns>
        public DataTable GetHotGameList(int GameID, string GameName, string ImgUrl)
        {
            return platformData.GetHotGameList(GameID, GameName, ImgUrl);
        }

        /// <summary>
        /// 下载中心
        /// </summary>
        /// <param name="GameID"></param>
        /// <param name="GameDes"></param>
        /// <param name="DownLoadAddr"></param>
        /// <param name="ORCodeAddr"></param>
        /// <returns></returns>
        public DataTable GetDownload(int GameID, string GameName)
        {
            return platformData.GetDownload(GameID, GameName);
        }

        //public DataTable GetRank(int GameID, string GameName, string GameStar, string DownloadCount)
        //{
        //    return platformData.GetRank(GameID, GameName, GameStar, DownloadCount);
        //}

        public DataTable GetShopProperty()
        {
            return platformData.GetShopProperty();
        }

    }
}
