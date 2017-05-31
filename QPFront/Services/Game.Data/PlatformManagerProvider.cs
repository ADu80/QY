using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;

using Game.Kernel;
using Game.IData;
using System.Data.Common;

namespace Game.Data
{
    /// <summary>
    /// 平台数据访问层
    /// </summary>
    public class PlatformManagerProvider : BaseDataProvider, IPlatformManagerProvider
    {
        #region 构造方法

        public PlatformManagerProvider(string connString)
            : base(connString)
        {

        }
        #endregion


        #region 兑换商城
        //兑换商城商品
        public PagerSet GoodsList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby)
        {
            return RunProc("EC_Get_Goods", pageIndex, pageSize, conditions);

        }
        //兑换商城商品
        public DataSet GoodsListByID(Dictionary<string, object> conditions)
        {
            return RunProcDs("EC_Get_Goods_ByID", conditions);

        }

        public DataSet GoodsImagesByID(Dictionary<string, object> conditions)
        {
            return RunProcDs("EC_Get_Goods_Images_ByID", conditions);
        }

        public PagerSet OrdersList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby)
        {
            return RunProc("EC_Get_Orders", pageIndex, pageSize, conditions);

        }
        public PagerSet GetOrderDetailList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby)
        {
            return RunProc("EC_Get_OrderDetails", pageIndex, pageSize, conditions);
        }
        public PagerSet ShopCarList(int pageIndex, int pageSize, Dictionary<string, object> conditions, string orderby)
        {
            return RunProc("EC_Get_ShopCar", pageIndex, pageSize, conditions);

        }
        public DataSet GetUser(Dictionary<string, object> conditions)
        {
            return RunProcDs("EC_Get_User", conditions);
        }
        public long OnShopCar(Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }
            Database.RunProc("EC_P_OnShopCar", prams);
            var p = prams.FindLast(el => { return true; });
            return Convert.ToInt64(p.Value ?? 0);
        }

        public int OnOrderCar(Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }
            prams.Add(Database.MakeOutParam("totalPrice", typeof(decimal)));
            int r = Database.RunProc("EC_P_OnOrder", prams);
            object oReturnValue = prams.LastOrDefault().Value;
            if (oReturnValue == DBNull.Value || oReturnValue == null)
                return 0;
            return Convert.ToInt32(oReturnValue);
        }

        public int OnOrderGood(Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }
            prams.Add(Database.MakeOutParam("totalPrice", typeof(decimal)));
            int r = Database.RunProc("EC_P_OnOrder_Ex", prams);
            object oReturnValue = prams.LastOrDefault().Value;
            if (oReturnValue == DBNull.Value || oReturnValue == null)
                return 0;
            return Convert.ToInt32(oReturnValue);
        }

        public int OnOrderCarArray(Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }
            prams.Add(Database.MakeOutParam("totalPrice", typeof(decimal)));
            int r = Database.RunProc("EC_P_OnOrder_Array", prams);
            object oReturnValue = prams.LastOrDefault().Value;
            if (oReturnValue == DBNull.Value || oReturnValue == null)
                return 0;
            return Convert.ToInt32(oReturnValue);
        }

        public int OnAddr(Dictionary<string, object> conditions)
        {
            var prams = new List<DbParameter>();
            foreach (var item in conditions)
            {
                prams.Add(Database.MakeInParam(item.Key, item.Value));
            }
            prams.Add(Database.MakeOutParam("getID", typeof(decimal)));
            int r = Database.RunProc("EC_P_OrderAddr", prams);
            var getId = prams[8].Value;
            return int.Parse(getId.ToString());
        }

        public DataSet GetUserAddr(Dictionary<string, object> conditions)
        {
            return RunProcDs("EC_Get_Addr", conditions);
        }

        public DataSet GetCitiesArea()
        {
            return RunProcDs("p_GetCityArea");
        }

        public DataTable GetDistrictsArea(string CityID)
        {
            Dictionary<string, object> prams = new Dictionary<string, object>();
            prams.Add("CityID", CityID);
            return RunProcDs("p_GetDistrictArea", prams).Tables[0];
        }

        #endregion

    }
}
