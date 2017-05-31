using System.Collections.Generic;
using System.Data;
using Game.Kernel;

namespace Game.IData
{
    /// <summary>
    /// 平台库数据层接口
    /// </summary>
    public interface IPlatformManagerProvider //: IProvider
    {

        #region 兑换商城 
        PagerSet GoodsList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby);
        DataSet GoodsListByID(Dictionary<string, object> conditions);
        DataSet GoodsImagesByID(Dictionary<string, object> conditions);
        PagerSet OrdersList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby);
        PagerSet GetOrderDetailList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby);
        PagerSet ShopCarList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby);
        DataSet GetUser(Dictionary<string, object> conditions);
        long OnShopCar(Dictionary<string, object> conditions);
        int OnOrderCar(Dictionary<string, object> conditions);
        int OnOrderGood(Dictionary<string, object> conditions);
        int OnOrderCarArray(Dictionary<string, object> conditions);
        int OnAddr(Dictionary<string, object> conditions);
        DataSet GetUserAddr(Dictionary<string, object> conditions);
        DataSet GetCitiesArea();
        DataTable GetDistrictsArea(string CityID);
        #endregion

    }
}
