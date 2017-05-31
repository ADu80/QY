using System.Collections.Generic;

using Game.Data.Factory;
using Game.IData;
using Game.Kernel;
using System.Data;

namespace Game.Facade
{
    /// <summary>
    /// 平台外观
    /// </summary>
    public class PlatformManagerFacade
    {
        #region Fields

        private IPlatformManagerProvider PlatformManagerData;

        #endregion

        #region 构造函数

        /// <summary>
        /// 构造函数
        /// </summary>
        public PlatformManagerFacade()
        {
            PlatformManagerData = ClassFactory.GetIPlatformManagerProvider();
        }
        #endregion



        #region 兑换商城
        public PagerSet GoodsList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby)
        {
            return PlatformManagerData.GoodsList(pageIndex, pageSize, conditions, orderby);
        }

        public DataSet GoodsListByID(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.GoodsListByID(conditions);
        }
        public DataSet GoodsImagesByID(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.GoodsImagesByID(conditions);
        }
        public PagerSet OrdersList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby)
        {
            return PlatformManagerData.OrdersList(pageIndex, pageSize, conditions, orderby);
        }
        public PagerSet GetOrderDetailList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby)
        {
            return PlatformManagerData.GetOrderDetailList(pageIndex, pageSize, conditions, orderby);
        }

        public DataSet GetUser(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.GetUser(conditions);
        }
        public DataSet GetUserAddr(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.GetUserAddr(conditions);
        }
        public PagerSet ShopCarList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby)
        {
            return PlatformManagerData.ShopCarList(pageIndex, pageSize, conditions, orderby);
        }

        public long OnShopCar(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.OnShopCar(conditions);
        }

        public int OnOrderCar(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.OnOrderCar(conditions);
        }

        public int OnOrderGood(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.OnOrderGood(conditions);
        }
        public int OnOrderCarArray(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.OnOrderCarArray(conditions);
        }
        public int OnAddr(Dictionary<string, object> conditions)
        {
            return PlatformManagerData.OnAddr(conditions);
        }
        public DataSet GetCitiesArea()
        {
            return PlatformManagerData.GetCitiesArea();
        }
        public DataTable GetDistrictsArea(string CityID)
        {
            return PlatformManagerData.GetDistrictsArea(CityID);
        }
        #endregion
    }
}
