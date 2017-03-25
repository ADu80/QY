using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Text;
using QPNativeWebDB.DataAccess;
using QPNativeWebDB.DbEntity;

namespace QPNativeWebDB.Business
{
    #region 逻辑访问类t_Products
    /// <summary>
    /// t_Products商品表 商品表逻辑访问类 扩展类
    /// </summary>
    public partial class bll_t_Products
    {
        //逻辑访问类 扩展方法
    }

    /// </summary>
    /// t_Products商品表 商品表逻辑访问类
    /// </summary>
    public partial class bll_t_Products
    {
        private readonly dal_t_Products dal = null;
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public bll_t_Products()
        {
            dal = new dal_t_Products();
        }
        /// <summary>
        /// 带参构造方法
        /// </summary>
        /// <param name="connectionSetting">配置连接字符串键名</param>
        public bll_t_Products(string connectionSetting)
        {
            dal = new dal_t_Products(connectionSetting);
        }
        #endregion

        #region 操作方法
        /// <summary>
        /// 增加一条数据
        /// </summary>
        /// <param name="model">商品表 商品表</param>
        /// <returns>int</returns>
        public int Add(mol_t_Products model)
        {
            return dal.Add(model);
        }
        /// <summary>
        /// 获取字段最大值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMaxValue(string sField)
        {
            return dal.GetMaxValue(sField);
        }
        /// <summary>
        /// 获取单个字段值
        /// </summary>
        /// <param name="sField">获取该字段值，空则默认主键值</param>
        /// <param name="Id">编号</param>
        /// <returns>object</returns>
        public object GetOneField(string sField, Int32 Id)
        {
            return dal.GetOneField(sField, Id);
        }
        /// <summary>
        /// 获取字段最小值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMinValue(string sField)
        {
            return dal.GetMinValue(sField);
        }
        /// <summary>
        /// 删除一条数据
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool Delete(Int32 Id)
        {
            return dal.Delete(Id);
        }
        /// <summary>
        /// 批量删除数据
        /// </summary>
        /// <param name="Ids">编号</param>
        /// <returns>bool</returns>
        public bool DeleteList(string Ids)
        {
            return dal.DeleteList(Ids);
        }
        /// <summary>
        /// 获取记录总数
        /// </summary>
        /// <param name="strWhere">查询条件</param>
        /// <returns>bool</returns>
        public int GetRecordCount(string strWhere)
        {
            return dal.GetRecordCount(strWhere);
        }
        /// <summary>
        /// 是否存在该记录
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool IsExists(Int32 Id)
        {
            return dal.IsExists(Id);
        }
        /// <summary>
        /// 更新一条数据
        /// </summary>
        /// <param name="model">商品表 商品表</param>
        /// <returns>bool</returns>
        public bool Update(mol_t_Products model)
        {
            return dal.Update(model);
        }
        /// <summary>
        /// 获取实体对象
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>mol_t_Products</returns>
        public mol_t_Products GetMOL(string sField, string strWhere)
        {
            return dal.GetMOL(sField, strWhere);
        }
        /// <summary>
        /// 获取实体对象集合
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>List mol_t_Products</returns>
        public List<mol_t_Products> GetListMOL(string sField, string strWhere)
        {
            return dal.GetListMOL(sField, strWhere);
        }
        /// <summary>
        /// 获取TOP行数据
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="sTop">TOP行数</param>
        /// <returns>DataSet</returns>
        public DataSet GetTopList(string sField, string strWhere, string sOrder, int sTop)
        {
            return dal.GetTopList(sField, strWhere, sOrder, sTop);
        }
        /// <summary>
        /// 数据分页
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(string sField, string strWhere, string sOrder, int PageSize, int PageIndex)
        {
            return dal.GetList(sField, strWhere, sOrder, PageSize, PageIndex);
        }
        /// <summary>
        /// 分页存储过程[proc_user_page] 返回数据集 1、数据集，2、总个数
        /// </summary>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(StringBuilder strWhere, string sOrder, int PageSize, int PageIndex)
        {
            return dal.GetList(strWhere, sOrder, PageSize, PageIndex);
        }
        #endregion
    }
    #endregion
    #region 逻辑访问类t_ExchapgerecOrd
    /// <summary>
    /// t_ExchapgerecOrd兑换记录 兑换记录逻辑访问类 扩展类
    /// </summary>
    public partial class bll_t_ExchapgerecOrd
    {
        //逻辑访问类 扩展方法
    }

    /// </summary>
    /// t_ExchapgerecOrd兑换记录 兑换记录逻辑访问类
    /// </summary>
    public partial class bll_t_ExchapgerecOrd
    {
        private readonly dal_t_ExchapgerecOrd dal = null;
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public bll_t_ExchapgerecOrd()
        {
            dal = new dal_t_ExchapgerecOrd();
        }
        /// <summary>
        /// 带参构造方法
        /// </summary>
        /// <param name="connectionSetting">配置连接字符串键名</param>
        public bll_t_ExchapgerecOrd(string connectionSetting)
        {
            dal = new dal_t_ExchapgerecOrd(connectionSetting);
        }
        #endregion

        #region 操作方法
        /// <summary>
        /// 增加一条数据
        /// </summary>
        /// <param name="model">兑换记录 兑换记录</param>
        /// <returns>int</returns>
        public int Add(mol_t_ExchapgerecOrd model)
        {
            return dal.Add(model);
        }
        /// <summary>
        /// 获取字段最大值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMaxValue(string sField)
        {
            return dal.GetMaxValue(sField);
        }
        /// <summary>
        /// 获取单个字段值
        /// </summary>
        /// <param name="sField">获取该字段值，空则默认主键值</param>
        /// <param name="Id">编号</param>
        /// <returns>object</returns>
        public object GetOneField(string sField, Int32 Id)
        {
            return dal.GetOneField(sField, Id);
        }
        /// <summary>
        /// 获取字段最小值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMinValue(string sField)
        {
            return dal.GetMinValue(sField);
        }
        /// <summary>
        /// 删除一条数据
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool Delete(Int32 Id)
        {
            return dal.Delete(Id);
        }
        /// <summary>
        /// 批量删除数据
        /// </summary>
        /// <param name="Ids">编号</param>
        /// <returns>bool</returns>
        public bool DeleteList(string Ids)
        {
            return dal.DeleteList(Ids);
        }
        /// <summary>
        /// 获取记录总数
        /// </summary>
        /// <param name="strWhere">查询条件</param>
        /// <returns>bool</returns>
        public int GetRecordCount(string strWhere)
        {
            return dal.GetRecordCount(strWhere);
        }
        /// <summary>
        /// 是否存在该记录
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool IsExists(Int32 Id)
        {
            return dal.IsExists(Id);
        }
        /// <summary>
        /// 更新一条数据
        /// </summary>
        /// <param name="model">兑换记录 兑换记录</param>
        /// <returns>bool</returns>
        public bool Update(mol_t_ExchapgerecOrd model)
        {
            return dal.Update(model);
        }
        /// <summary>
        /// 获取实体对象
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>mol_t_ExchapgerecOrd</returns>
        public mol_t_ExchapgerecOrd GetMOL(string sField, string strWhere)
        {
            return dal.GetMOL(sField, strWhere);
        }
        /// <summary>
        /// 获取实体对象集合
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>List mol_t_ExchapgerecOrd</returns>
        public List<mol_t_ExchapgerecOrd> GetListMOL(string sField, string strWhere)
        {
            return dal.GetListMOL(sField, strWhere);
        }
        /// <summary>
        /// 获取TOP行数据
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="sTop">TOP行数</param>
        /// <returns>DataSet</returns>
        public DataSet GetTopList(string sField, string strWhere, string sOrder, int sTop)
        {
            return dal.GetTopList(sField, strWhere, sOrder, sTop);
        }
        /// <summary>
        /// 数据分页
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(string sField, string strWhere, string sOrder, int PageSize, int PageIndex)
        {
            return dal.GetList(sField, strWhere, sOrder, PageSize, PageIndex);
        }
        /// <summary>
        /// 分页存储过程[proc_user_page] 返回数据集 1、数据集，2、总个数
        /// </summary>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(StringBuilder strWhere, string sOrder, int PageSize, int PageIndex)
        {
            return dal.GetList(strWhere, sOrder, PageSize, PageIndex);
        }
        #endregion
    }
    #endregion
    #region 逻辑访问类t_Orders
    /// <summary>
    /// t_Orders兑换订单 兑换订单逻辑访问类 扩展类
    /// </summary>
    public partial class bll_t_Orders
    {
        //逻辑访问类 扩展方法

        public DataSet GetListView(string sField, string strWhere, string sOrder, int PageSize, int PageIndex)
        {
            return dal.GetListView(sField, strWhere, sOrder, PageSize, PageIndex);
        }
        public bool UpdateProcess(mol_t_Orders model)
        {
            return dal.UpdateProcess(model);
        }
    }

    /// </summary>
    /// t_Orders兑换订单 兑换订单逻辑访问类
    /// </summary>
    public partial class bll_t_Orders
    {
        private readonly dal_t_Orders dal = null;
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public bll_t_Orders()
        {
            dal = new dal_t_Orders();
        }
        /// <summary>
        /// 带参构造方法
        /// </summary>
        /// <param name="connectionSetting">配置连接字符串键名</param>
        public bll_t_Orders(string connectionSetting)
        {
            dal = new dal_t_Orders(connectionSetting);
        }
        #endregion

        #region 操作方法
        /// <summary>
        /// 增加一条数据
        /// </summary>
        /// <param name="model">兑换订单 兑换订单</param>
        /// <returns>int</returns>
        public int Add(mol_t_Orders model)
        {
            return dal.Add(model);
        }
        /// <summary>
        /// 获取字段最大值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMaxValue(string sField)
        {
            return dal.GetMaxValue(sField);
        }
        /// <summary>
        /// 获取单个字段值
        /// </summary>
        /// <param name="sField">获取该字段值，空则默认主键值</param>
        /// <param name="Id">编号</param>
        /// <returns>object</returns>
        public object GetOneField(string sField, Int32 Id)
        {
            return dal.GetOneField(sField, Id);
        }
        /// <summary>
        /// 获取字段最小值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMinValue(string sField)
        {
            return dal.GetMinValue(sField);
        }
        /// <summary>
        /// 删除一条数据
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool Delete(Int32 Id)
        {
            return dal.Delete(Id);
        }
        /// <summary>
        /// 批量删除数据
        /// </summary>
        /// <param name="Ids">编号</param>
        /// <returns>bool</returns>
        public bool DeleteList(string Ids)
        {
            return dal.DeleteList(Ids);
        }
        /// <summary>
        /// 获取记录总数
        /// </summary>
        /// <param name="strWhere">查询条件</param>
        /// <returns>bool</returns>
        public int GetRecordCount(string strWhere)
        {
            return dal.GetRecordCount(strWhere);
        }
        /// <summary>
        /// 是否存在该记录
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool IsExists(Int32 Id)
        {
            return dal.IsExists(Id);
        }
        /// <summary>
        /// 更新一条数据
        /// </summary>
        /// <param name="model">兑换订单 兑换订单</param>
        /// <returns>bool</returns>
        public bool Update(mol_t_Orders model)
        {
            return dal.Update(model);
        }
        /// <summary>
        /// 获取实体对象
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>mol_t_Orders</returns>
        public mol_t_Orders GetMOL(string sField, string strWhere)
        {
            return dal.GetMOL(sField, strWhere);
        }
        /// <summary>
        /// 获取实体对象集合
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>List mol_t_Orders</returns>
        public List<mol_t_Orders> GetListMOL(string sField, string strWhere)
        {
            return dal.GetListMOL(sField, strWhere);
        }
        /// <summary>
        /// 获取TOP行数据
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="sTop">TOP行数</param>
        /// <returns>DataSet</returns>
        public DataSet GetTopList(string sField, string strWhere, string sOrder, int sTop)
        {
            return dal.GetTopList(sField, strWhere, sOrder, sTop);
        }
        /// <summary>
        /// 数据分页
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(string sField, string strWhere, string sOrder, int PageSize, int PageIndex)
        {
            return dal.GetList(sField, strWhere, sOrder, PageSize, PageIndex);
        }
        /// <summary>
        /// 分页存储过程[proc_user_page] 返回数据集 1、数据集，2、总个数
        /// </summary>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(StringBuilder strWhere, string sOrder, int PageSize, int PageIndex)
        {
            return dal.GetList(strWhere, sOrder, PageSize, PageIndex);
        }
        #endregion
    }
    #endregion
}