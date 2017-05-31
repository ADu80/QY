using Game.Entity.NativeWeb;
using Game.Kernel;
using QPFront.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace QPFront.Controller
{
    public class ExchangeController : ControllerBase, IController
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

        //获取玩家
        public string GetUser(HttpRequest req)
        {
            try
            {
                var GameID = req["GameID"] == null ? "-1" : req["GameID"];
                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("GameID", GameID);//玩家游戏ID  

                DataSet ds = aidePlatformManagerFacade.GetUser(conditions2);

                string json = GetJsonByDataTable(ds.Tables[0]);
                return JsonResultHelper.GetSuccessJsonByArray(json);

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        //商品列表
        public string GoodsList(HttpRequest req)
        {
            try
            {
                var GoodID = req["GoodID"];
                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                DataTable dt = null;
                string json = "";
                if (!string.IsNullOrEmpty(GoodID))
                {
                    conditions2.Add("GoodID", GoodID);//商品名称 
                    DataSet ds = aidePlatformManagerFacade.GoodsListByID(conditions2);
                    DataSet dsimg = aidePlatformManagerFacade.GoodsImagesByID(conditions2);
                    dt = ds.Tables[0];
                    DataTable dtimg = dsimg.Tables[0];
                    string json1 = GetJsonByDataTable(dtimg);
                    dt.Columns.Add("images", typeof(string));
                    dt.Rows[0]["images"] = json1;
                }
                else
                {
                    var CategoryID = req["CategoryID"];
                    var GoodName = req["GoodName"];
                    conditions2.Add("CategoryID", CategoryID);//商品分类 0 全部
                    conditions2.Add("GoodName", GoodName);//商品名称 
                    PagerSet pagerSet2 = aidePlatformManagerFacade.GoodsList(1, 1000, conditions2, "ORDER BY ID DESC");
                    dt = pagerSet2.PageSet.Tables[1];
                    DataTable dtimg = pagerSet2.PageSet.Tables[2];
                    dt.Columns.Add("images", typeof(string));
                    foreach (DataRow dr in dt.Rows)
                    {
                        DataTable dtimg2 = dtimg.Clone();
                        var drsimg = dtimg.Select("GoodID=" + dr["ID"].ToString());
                        foreach (DataRow dr2 in drsimg)
                        {
                            DataRow newRow2 = dtimg2.NewRow();
                            foreach (DataColumn dc2 in dtimg2.Columns)
                            {
                                newRow2[dc2.ColumnName] = dr2[dc2.ColumnName];
                            }
                            dtimg2.Rows.Add(newRow2);
                        }
                        string json1 = GetJsonByDataTable(dtimg2);
                        dr["images"] = json1;
                    }
                }
                json = GetJsonByDataTable(dt);
                json = json.Replace("\"[", "[").Replace("]\"", "]");
                return JsonResultHelper.GetSuccessJsonByArray(json);

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        //兑换列表 OrderDetails 包含 订单商品列表
        public string OrdersList(HttpRequest req)
        {
            try
            {
                var OrderNo = req["OrderNo"];
                var Accounts = req["Accounts"];
                var startDate = req["startDate"];
                var endDate = req["endDate"];
                var UserID = req["UserID"];
                var GameID = req["GameID"];


                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("OrderNo", OrderNo);//订单号
                conditions2.Add("Accounts", Accounts);//玩家账号
                conditions2.Add("startDate", startDate);//开始时间
                conditions2.Add("endDate", endDate);//结束时间
                conditions2.Add("UserID", UserID);//玩家ID
                conditions2.Add("GameID", GameID);//游戏ID

                PagerSet pagerSet2 = aidePlatformManagerFacade.OrdersList(1, 1000, conditions2, "ORDER BY ID DESC");
                DataTable dt = pagerSet2.PageSet.Tables[1];
                dt.Columns.Add("OrderDetails", typeof(System.String));
                foreach (DataRow item in dt.Rows)
                {
                    Dictionary<string, object> subconditions2 = new Dictionary<string, object>();
                    subconditions2.Add("OrderID", item["ID"].ToString());//订单ID
                    PagerSet subpagerSet2 = aidePlatformManagerFacade.GetOrderDetailList(1, 1000, subconditions2, "ORDER BY ID DESC");
                    string json0 = GetJsonByDataTable(subpagerSet2.PageSet.Tables[1]);
                    item["OrderDetails"] = json0;
                }

                string json = GetJsonByDataTable2(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        //购物车列表
        public string ShopCarList(HttpRequest req)
        {
            try
            {
                var GameID = req["GameID"].Replace("\"", "");
                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("GameID", GameID);//玩家游戏ID  

                PagerSet pagerSet2 = aidePlatformManagerFacade.ShopCarList(1, 1000, conditions2, "ORDER BY ID DESC");

                DataTable dt = pagerSet2.PageSet.Tables[1];
                string json = GetJsonByDataTable(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        //购物车操作
        public string OnShopCar(HttpRequest req)
        {
            try
            {
                var GameID = req["GameID"];
                var GoodID = req["GoodID"];
                var Num = req["Num"];
                var PayType = req["PayType"];
                var EditType = req["EditType"];

                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("GameID", GameID);//玩家游戏ID 
                conditions2.Add("GoodID", GoodID);//商品ID
                conditions2.Add("Num", Num);//商品数量
                conditions2.Add("PayType", PayType);//商品兑换方式 1 金币 2钻石 3积分
                conditions2.Add("EditType", EditType);//1 添加到购物车 2 修改 3删除

                long result = aidePlatformManagerFacade.OnShopCar(conditions2);


                return JsonResultHelper.GetSuccessJsonByArray(result.ToString());

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        public string NewOrder
        {
            get { return DateTime.Now.ToString("yyyyMMddhhmmss") + new Random().Next(1000); }
        }

        //兑换操作-购物车下单(全部)
        public string OnOrder(HttpRequest req)
        {
            try
            {
                var GameID = req["GameID"];
                var AddrID = req["AddrID"];

                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("OrderNo", NewOrder);//订单号
                conditions2.Add("GameID", GameID);//玩家ID
                conditions2.Add("AddrID", AddrID);// 玩家地址ID

                int result = aidePlatformManagerFacade.OnOrderCar(conditions2);
                /// result  返回-1 金币不足 -2钻石不足 -3购物车为空
                return JsonResultHelper.GetSuccessJsonByArray(result.ToString());

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        //兑换操作-购物车下单(选择部分)
        public string OnOrderCar(HttpRequest req)
        {
            try
            {
                var GameID = req["GameID"];
                var AddrID = req["AddrID"];
                var CarArray = req["CarArray"];
                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("OrderNo", NewOrder);//订单号
                conditions2.Add("GameID", GameID);//玩家ID
                conditions2.Add("AddrID", AddrID);// 玩家地址ID
                conditions2.Add("CarArray", CarArray);// 购物车ID “27,28”
                int ires = aidePlatformManagerFacade.OnOrderCarArray(conditions2);
                /// result 返回-1 金币不足 -2钻石不足 -3购物车为空
                string res = getOnOrderCarMessage(ires);
                return res;

            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        string getOnOrderCarMessage(int type)
        {
            switch (type)
            {
                case -1: return JsonResultHelper.GetErrorJson("金币不足");
                case -2: return JsonResultHelper.GetErrorJson("钻石不足");
                case -3: return JsonResultHelper.GetErrorJson("购物车为空");
                default: return JsonResultHelper.GetSuccessJson("成功");
            }
        }

        //兑换操作-单商品直接兑换
        public string OnOrderGood(HttpRequest req)
        {
            try
            {
                var GameID = req["GameID"];
                var AddrID = req["AddrID"];
                var GoodID = req["GoodID"];
                var Num = req["Num"];
                var PayType = req["PayType"];
                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("OrderNo", NewOrder);//订单号
                conditions2.Add("GameID", GameID);//玩家ID
                conditions2.Add("AddrID", AddrID);// 玩家地址ID
                conditions2.Add("GoodID", GoodID);// 商品ID
                conditions2.Add("Num", Num);// 商品数量
                conditions2.Add("PayType", PayType);// 兑换类型 1 金币 2钻石 3积分

                int result = aidePlatformManagerFacade.OnOrderGood(conditions2);
                /// result 返回-1 金币不足 -2钻石不足
                return JsonResultHelper.GetSuccessJsonByArray(result.ToString());

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }


        //返回 ID 添加地址
        public string OnAddr(HttpRequest req)
        {
            try
            {
                var ID = req["ID"];
                var GameID = req["GameID"];
                var ProvinceID = req["ProvinceID"];
                var CountryID = req["CountryID"];
                var CityID = req["CityID"];
                var DistrictsID = req["DistrictsID"];
                var ReceiverName = req["ReceiverName"];
                var ReceiverMobile = req["ReceiverMobile"];
                var Addr = req["Addr"];
                var Street = req["Street"];
                var IsDefault = req["IsDefault"];

                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("ID", ID);//0 添加 , >0 修改
                conditions2.Add("GameID", GameID);
                conditions2.Add("ProviceID", ProvinceID);
                conditions2.Add("CountryID", CountryID);
                conditions2.Add("CityID", CityID);
                conditions2.Add("DistrictID", DistrictsID);
                conditions2.Add("ReceiverName", ReceiverName);
                conditions2.Add("ReceiverMobile", ReceiverMobile);
                conditions2.Add("Addr", Addr);
                conditions2.Add("Street", Street);
                conditions2.Add("IsDefault", IsDefault);//0不是默认 1默认地址

                int result = aidePlatformManagerFacade.OnAddr(conditions2);


                return JsonResultHelper.GetSuccessJsonByArray(result.ToString());

            }
            catch (Exception ex)
            {

                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        //获取玩家地址 
        public string GetUserAddr(HttpRequest req)
        {
            try
            {
                var GameID = req["GameID"] ?? "-1";
                var AddrID = req["AddrID"] ?? "-1";
                Dictionary<string, object> conditions2 = new Dictionary<string, object>();
                conditions2.Add("GameID", GameID);//玩家游戏ID  
                conditions2.Add("AddrID", AddrID);//地址ID 
                DataSet ds = aidePlatformManagerFacade.GetUserAddr(conditions2);

                string json = GetJsonByDataTable(ds.Tables[0]);
                return JsonResultHelper.GetSuccessJsonByArray(json);

            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }

        public string CitiesArea(HttpRequest req)
        {
            try
            {
                DataSet ds = aidePlatformManagerFacade.GetCitiesArea();
                ds.Tables[0].TableName = "Countrys";
                ds.Tables[1].TableName = "Provinces";
                ds.Tables[2].TableName = "Cities";

                string json = GetJsonByDataSet(ds);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }
        public string DistrictsArea(HttpRequest req)
        {
            try
            {
                var CityID = req["CityID"];
                DataTable dt = aidePlatformManagerFacade.GetDistrictsArea(CityID);

                string json = GetJsonByDataTable(dt);
                return JsonResultHelper.GetSuccessJsonByArray(json);
            }
            catch (Exception ex)
            {
                return JsonResultHelper.GetErrorJson(ex.Message); ;
            }
        }
    }
}
