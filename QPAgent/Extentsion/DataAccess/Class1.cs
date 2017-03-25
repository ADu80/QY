using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Text;
using QPNativeWebDB.DbHelper;
using QPNativeWebDB.DbEntity;

namespace QPNativeWebDB.DataAccess
{
    #region 数据访问类t_Products
    /// <summary>
    /// t_Products商品表 商品表数据访问类 扩展类
    /// </summary>
    public partial class dal_t_Products
    {
        //数据访问类 扩展方法
    }

    /// <summary>
    /// t_Products商品表 商品表数据访问类
    /// </summary>
    public partial class dal_t_Products
    {
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public dal_t_Products()
        {
        }
        /// <summary>
        /// 带参构造方法
        /// </summary>
        /// <param name="connectionSetting">配置连接字符串键名</param>
        public dal_t_Products(string connectionSetting)
        {
            DbHelper.DbHelperSQL.connectionSetting = connectionSetting;
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
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into t_Products(");
            strSql.Append("maxImage,Costnum,Stocknum,State,CreateDate,ProductName,SalePrice,Description,minImage)  values (");
            strSql.Append("@maxImage,@Costnum,@Stocknum,@State,@CreateDate,@ProductName,@SalePrice,@Description,@minImage)");
            strSql.Append(";select @@IDENTITY");
            SqlParameter[] parameters = {
					new SqlParameter("@maxImage", SqlDbType.VarChar,300),
					new SqlParameter("@Costnum", SqlDbType.Int,10),
					new SqlParameter("@Stocknum", SqlDbType.Int,10),
					new SqlParameter("@State", SqlDbType.Bit,1),
					new SqlParameter("@CreateDate", SqlDbType.DateTime,23),
					new SqlParameter("@ProductName", SqlDbType.VarChar,100),
					new SqlParameter("@SalePrice", SqlDbType.Int,10),
					new SqlParameter("@Description", SqlDbType.VarChar,8000),
					new SqlParameter("@minImage", SqlDbType.VarChar,300)};
            parameters[0].Value = model.maxImage;
            parameters[1].Value = model.Costnum;
            parameters[2].Value = model.Stocknum;
            parameters[3].Value = model.State;
            parameters[4].Value = model.CreateDate;
            parameters[5].Value = model.ProductName;
            parameters[6].Value = model.SalePrice;
            parameters[7].Value = model.Description;
            parameters[8].Value = model.minImage;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            if (obj == null)
            {
                return 0;
            }
            else
            {
                return Convert.ToInt32(obj);
            }
        }
        /// <summary>
        /// 获取字段最大值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMaxValue(string sField)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT ISNULL(MAX(");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
                strSql.Append("),0) AS ").Append(sField);
            }
            else
            {
                strSql.Append("Id),0) AS Id");
            }
            strSql.Append(" FROM t_Products");
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            return Convert.ToInt32(obj);
        }
        /// <summary>
        /// 获取单个字段值
        /// </summary>
        /// <param name="sField">获取该字段值，空则默认主键值</param>
        /// <param name="Id">编号</param>
        /// <returns>object</returns>
        public object GetOneField(string sField, Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT TOP 1 ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id");
            }
            strSql.Append(" FROM t_Products ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            return obj;
        }
        /// <summary>
        /// 获取字段最小值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMinValue(string sField)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT ISNULL(MIN(");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
                strSql.Append("),0) AS ").Append(sField);
            }
            else
            {
                strSql.Append("Id),0) AS Id");
            }
            strSql.Append(" FROM t_Products");
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            return Convert.ToInt32(obj);
        }
        /// <summary>
        /// 删除一条数据
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool Delete(Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("delete from t_Products ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString(), parameters);
            return rows > 0;
        }
        /// <summary>
        /// 批量删除数据
        /// </summary>
        /// <param name="Ids">编号</param>
        /// <returns>bool</returns>
        public bool DeleteList(string Ids)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("delete from t_Products ");
            strSql.AppendFormat("WHERE Id IN({0})", Ids);
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString());
            return rows > 0;
        }
        /// <summary>
        /// 获取记录总数
        /// </summary>
        /// <param name="strWhere">查询条件</param>
        /// <returns>bool</returns>
        public int GetRecordCount(string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select count(1) FROM t_Products WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            if (obj == null)
            {
                return 0;
            }
            else
            {
                return Convert.ToInt32(obj);
            }
        }
        /// <summary>
        /// 是否存在该记录
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool IsExists(Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select count(1) from t_Products ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            if ((Object.Equals(obj, null)) || (Object.Equals(obj, System.DBNull.Value)))
            {
                return false;
            }
            else
            {
                return int.Parse(obj.ToString()) > 0;
            }
        }
        /// <summary>
        /// 更新一条数据
        /// </summary>
        /// <param name="model">商品表 商品表</param>
        /// <returns>bool</returns>
        public bool Update(mol_t_Products model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update t_Products set ");
            strSql.Append("maxImage=@maxImage,");
            strSql.Append("Costnum=@Costnum,");
            strSql.Append("Stocknum=@Stocknum,");
            strSql.Append("State=@State,");
            strSql.Append("CreateDate=@CreateDate,");
            strSql.Append("ProductName=@ProductName,");
            strSql.Append("SalePrice=@SalePrice,");
            strSql.Append("Description=@Description,");
            strSql.Append("minImage=@minImage ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
					new SqlParameter("@maxImage", SqlDbType.VarChar,300),
					new SqlParameter("@Costnum", SqlDbType.Int,10),
					new SqlParameter("@Stocknum", SqlDbType.Int,10),
					new SqlParameter("@State", SqlDbType.Bit,1),
					new SqlParameter("@CreateDate", SqlDbType.DateTime,23),
					new SqlParameter("@ProductName", SqlDbType.VarChar,100),
					new SqlParameter("@SalePrice", SqlDbType.Int,10),
					new SqlParameter("@Description", SqlDbType.VarChar,8000),
					new SqlParameter("@minImage", SqlDbType.VarChar,300),
					new SqlParameter("@Id", SqlDbType.Int,10)};
            parameters[0].Value = model.maxImage;
            parameters[1].Value = model.Costnum;
            parameters[2].Value = model.Stocknum;
            parameters[3].Value = model.State;
            parameters[4].Value = model.CreateDate;
            parameters[5].Value = model.ProductName;
            parameters[6].Value = model.SalePrice;
            parameters[7].Value = model.Description;
            parameters[8].Value = model.minImage;
            parameters[9].Value = model.Id;
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString(), parameters);
            return rows > 0;
        }
        /// <summary>
        /// 获取实体对象
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>mol_t_Products</returns>
        public mol_t_Products GetMOL(string sField, string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(1) ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,maxImage,Costnum,Stocknum,State,CreateDate,ProductName,SalePrice,Description,minImage");
            }
            strSql.Append(" FROM t_Products WHERE 1=1 ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            SqlDataReader SqlReader = DbHelperSQL.DataReaderSql(strSql.ToString());
            return DbHelperMOL.ReaderToModel<mol_t_Products>(SqlReader);
        }
        /// <summary>
        /// 获取实体对象集合
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>List mol_t_Products</returns>
        public List<mol_t_Products> GetListMOL(string sField, string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,maxImage,Costnum,Stocknum,State,CreateDate,ProductName,SalePrice,Description,minImage");
            }
            strSql.Append(" FROM t_Products WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            SqlDataReader SqlReader = DbHelperSQL.DataReaderSql(strSql.ToString());
            return DbHelperMOL.ReaderToList<mol_t_Products>(SqlReader);
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
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(").Append(sTop).Append(") ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,maxImage,Costnum,Stocknum,State,CreateDate,ProductName,SalePrice,Description,minImage");
            }
            strSql.Append(" FROM t_Products WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(" ORDER BY ");
            if (!string.IsNullOrEmpty(sOrder))
            {
                strSql.Append(sOrder);
            }
            else
            {
                strSql.Append("Id ASC;");
            }
            return DbHelperSQL.DataSetSql(strSql.ToString());
        }
        /// <summary>
        /// SQL表数据分页
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(string sField, string strWhere, string sOrder, int PageSize, int PageIndex)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(");
            strSql.Append(PageSize).Append(") ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,maxImage,Costnum,Stocknum,State,CreateDate,ProductName,SalePrice,Description,minImage");
            }
            strSql.Append(" FROM t_Products WHERE Id");
            strSql.Append(" > (SELECT ISNULL(MAX(Id),0) AS Id FROM(SELECT TOP(").Append((PageIndex - 1) * PageSize).Append(") Id FROM t_Products");
            strSql.Append(" WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(" ORDER BY Id ASC) t) ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(";SELECT COUNT(1) AS total FROM t_Products WHERE 1=1 ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            return DbHelperSQL.DataSetSql(strSql.ToString());
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
            SqlParameter[] parameters = {
				new SqlParameter("@TableNames", SqlDbType.VarChar, 200),
				new SqlParameter("@PrimaryKey", SqlDbType.VarChar, 100),
				new SqlParameter("@Fields", SqlDbType.VarChar, 300),
				new SqlParameter("@Filter", SqlDbType.VarChar, 300),
				new SqlParameter("@Group", SqlDbType.VarChar, 200),
				new SqlParameter("@Order", SqlDbType.VarChar, 200),
				new SqlParameter("@PageSize", SqlDbType.Int),
				new SqlParameter("@CurrentPage", SqlDbType.Int)};
            parameters[0].Value = "t_Products";
            parameters[1].Value = "Id";
            parameters[2].Value = "Id,maxImage,Costnum,Stocknum,State,CreateDate,ProductName,SalePrice,Description,minImage";
            parameters[3].Value = strWhere.ToString();
            parameters[4].Value = "";
            parameters[5].Value = sOrder;
            parameters[6].Value = PageSize;
            parameters[7].Value = PageIndex - 1;
            return DbHelperSQL.DataSetSql("proc_user_page", CommandType.StoredProcedure, parameters);
        }
        #endregion
    }
    #endregion
    #region 数据访问类t_ExchapgerecOrd
    /// <summary>
    /// t_ExchapgerecOrd兑换记录 兑换记录数据访问类 扩展类
    /// </summary>
    public partial class dal_t_ExchapgerecOrd
    {
        //数据访问类 扩展方法
    }

    /// <summary>
    /// t_ExchapgerecOrd兑换记录 兑换记录数据访问类
    /// </summary>
    public partial class dal_t_ExchapgerecOrd
    {
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public dal_t_ExchapgerecOrd()
        {
        }
        /// <summary>
        /// 带参构造方法
        /// </summary>
        /// <param name="connectionSetting">配置连接字符串键名</param>
        public dal_t_ExchapgerecOrd(string connectionSetting)
        {
            DbHelper.DbHelperSQL.connectionSetting = connectionSetting;
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
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into t_ExchapgerecOrd(");
            strSql.Append("Rid,UserID,Price,Num,CreateDate)  values (");
            strSql.Append("@Rid,@UserID,@Price,@Num,@CreateDate)");
            strSql.Append(";select @@IDENTITY");
            SqlParameter[] parameters = {
					new SqlParameter("@Rid", SqlDbType.Int,10),
					new SqlParameter("@UserID", SqlDbType.Int,10),
					new SqlParameter("@Price", SqlDbType.Int,10),
					new SqlParameter("@Num", SqlDbType.Int,10),
					new SqlParameter("@CreateDate", SqlDbType.DateTime,23)};
            parameters[0].Value = model.Rid;
            parameters[1].Value = model.UserID;
            parameters[2].Value = model.Price;
            parameters[3].Value = model.Num;
            parameters[4].Value = model.CreateDate;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            if (obj == null)
            {
                return 0;
            }
            else
            {
                return Convert.ToInt32(obj);
            }
        }
        /// <summary>
        /// 获取字段最大值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMaxValue(string sField)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT ISNULL(MAX(");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
                strSql.Append("),0) AS ").Append(sField);
            }
            else
            {
                strSql.Append("Id),0) AS Id");
            }
            strSql.Append(" FROM t_ExchapgerecOrd");
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            return Convert.ToInt32(obj);
        }
        /// <summary>
        /// 获取单个字段值
        /// </summary>
        /// <param name="sField">获取该字段值，空则默认主键值</param>
        /// <param name="Id">编号</param>
        /// <returns>object</returns>
        public object GetOneField(string sField, Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT TOP 1 ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id");
            }
            strSql.Append(" FROM t_ExchapgerecOrd ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            return obj;
        }
        /// <summary>
        /// 获取字段最小值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMinValue(string sField)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT ISNULL(MIN(");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
                strSql.Append("),0) AS ").Append(sField);
            }
            else
            {
                strSql.Append("Id),0) AS Id");
            }
            strSql.Append(" FROM t_ExchapgerecOrd");
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            return Convert.ToInt32(obj);
        }
        /// <summary>
        /// 删除一条数据
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool Delete(Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("delete from t_ExchapgerecOrd ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString(), parameters);
            return rows > 0;
        }
        /// <summary>
        /// 批量删除数据
        /// </summary>
        /// <param name="Ids">编号</param>
        /// <returns>bool</returns>
        public bool DeleteList(string Ids)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("delete from t_ExchapgerecOrd ");
            strSql.AppendFormat("WHERE Id IN({0})", Ids);
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString());
            return rows > 0;
        }
        /// <summary>
        /// 获取记录总数
        /// </summary>
        /// <param name="strWhere">查询条件</param>
        /// <returns>bool</returns>
        public int GetRecordCount(string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select count(1) FROM t_ExchapgerecOrd WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            if (obj == null)
            {
                return 0;
            }
            else
            {
                return Convert.ToInt32(obj);
            }
        }
        /// <summary>
        /// 是否存在该记录
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool IsExists(Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select count(1) from t_ExchapgerecOrd ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            if ((Object.Equals(obj, null)) || (Object.Equals(obj, System.DBNull.Value)))
            {
                return false;
            }
            else
            {
                return int.Parse(obj.ToString()) > 0;
            }
        }
        /// <summary>
        /// 更新一条数据
        /// </summary>
        /// <param name="model">兑换记录 兑换记录</param>
        /// <returns>bool</returns>
        public bool Update(mol_t_ExchapgerecOrd model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update t_ExchapgerecOrd set ");
            strSql.Append("Rid=@Rid,");
            strSql.Append("UserID=@UserID,");
            strSql.Append("Price=@Price,");
            strSql.Append("Num=@Num,");
            strSql.Append("CreateDate=@CreateDate ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
					new SqlParameter("@Rid", SqlDbType.Int,10),
					new SqlParameter("@UserID", SqlDbType.Int,10),
					new SqlParameter("@Price", SqlDbType.Int,10),
					new SqlParameter("@Num", SqlDbType.Int,10),
					new SqlParameter("@CreateDate", SqlDbType.DateTime,23),
					new SqlParameter("@Id", SqlDbType.Int,10)};
            parameters[0].Value = model.Rid;
            parameters[1].Value = model.UserID;
            parameters[2].Value = model.Price;
            parameters[3].Value = model.Num;
            parameters[4].Value = model.CreateDate;
            parameters[5].Value = model.Id;
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString(), parameters);
            return rows > 0;
        }
        /// <summary>
        /// 获取实体对象
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>mol_t_ExchapgerecOrd</returns>
        public mol_t_ExchapgerecOrd GetMOL(string sField, string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(1) ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,Rid,UserID,Price,Num,CreateDate");
            }
            strSql.Append(" FROM t_ExchapgerecOrd WHERE 1=1 ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            SqlDataReader SqlReader = DbHelperSQL.DataReaderSql(strSql.ToString());
            return DbHelperMOL.ReaderToModel<mol_t_ExchapgerecOrd>(SqlReader);
        }
        /// <summary>
        /// 获取实体对象集合
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>List mol_t_ExchapgerecOrd</returns>
        public List<mol_t_ExchapgerecOrd> GetListMOL(string sField, string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,Rid,UserID,Price,Num,CreateDate");
            }
            strSql.Append(" FROM t_ExchapgerecOrd WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            SqlDataReader SqlReader = DbHelperSQL.DataReaderSql(strSql.ToString());
            return DbHelperMOL.ReaderToList<mol_t_ExchapgerecOrd>(SqlReader);
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
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(").Append(sTop).Append(") ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,Rid,UserID,Price,Num,CreateDate");
            }
            strSql.Append(" FROM t_ExchapgerecOrd WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(" ORDER BY ");
            if (!string.IsNullOrEmpty(sOrder))
            {
                strSql.Append(sOrder);
            }
            else
            {
                strSql.Append("Id ASC;");
            }
            return DbHelperSQL.DataSetSql(strSql.ToString());
        }
        /// <summary>
        /// SQL表数据分页
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(string sField, string strWhere, string sOrder, int PageSize, int PageIndex)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(");
            strSql.Append(PageSize).Append(") ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,Rid,UserID,Price,Num,CreateDate");
            }
            strSql.Append(" FROM t_ExchapgerecOrd WHERE Id");
            strSql.Append(" > (SELECT ISNULL(MAX(Id),0) AS Id FROM(SELECT TOP(").Append((PageIndex - 1) * PageSize).Append(") Id FROM t_ExchapgerecOrd");
            strSql.Append(" WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(" ORDER BY Id ASC) t) ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(";SELECT COUNT(1) AS total FROM t_ExchapgerecOrd WHERE 1=1 ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            return DbHelperSQL.DataSetSql(strSql.ToString());
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
            SqlParameter[] parameters = {
				new SqlParameter("@TableNames", SqlDbType.VarChar, 200),
				new SqlParameter("@PrimaryKey", SqlDbType.VarChar, 100),
				new SqlParameter("@Fields", SqlDbType.VarChar, 300),
				new SqlParameter("@Filter", SqlDbType.VarChar, 300),
				new SqlParameter("@Group", SqlDbType.VarChar, 200),
				new SqlParameter("@Order", SqlDbType.VarChar, 200),
				new SqlParameter("@PageSize", SqlDbType.Int),
				new SqlParameter("@CurrentPage", SqlDbType.Int)};
            parameters[0].Value = "t_ExchapgerecOrd";
            parameters[1].Value = "Id";
            parameters[2].Value = "Id,Rid,UserID,Price,Num,CreateDate";
            parameters[3].Value = strWhere.ToString();
            parameters[4].Value = "";
            parameters[5].Value = sOrder;
            parameters[6].Value = PageSize;
            parameters[7].Value = PageIndex - 1;
            return DbHelperSQL.DataSetSql("proc_user_page", CommandType.StoredProcedure, parameters);
        }
        #endregion
    }
    #endregion
    #region 数据访问类t_Orders
    /// <summary>
    /// t_Orders兑换订单 兑换订单数据访问类 扩展类
    /// </summary>
    public partial class dal_t_Orders
    {
        //数据访问类 扩展方法
        //分页视图
        public DataSet GetListView(string sField, string strWhere, string sOrder, int PageSize, int PageIndex)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(");
            strSql.Append(PageSize).Append(") ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Accounts,productname,Id,opratorId,PROCESS,Email,Postalcode,TellPhone,CreateDate,Cost,UserID,OrderId,States,UserName,AddDress,Cost2,Remarks,Cost1,Rid");
            }
            strSql.Append(" FROM v_Orders ");
           // strSql.Append(" FROM v_Orders WHERE Id");
           // strSql.Append(" > (SELECT ISNULL(MAX(Id),0) AS Id FROM(SELECT TOP(").Append((PageIndex - 1) * PageSize).Append(") Id FROM v_Orders");
            strSql.Append(" WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            //strSql.Append(" ORDER BY Id ASC) t) ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(";SELECT COUNT(1) AS total FROM v_Orders WHERE 1=1 ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            return DbHelperSQL.DataSetSql(strSql.ToString());
        }
        //处理订单
        public bool UpdateProcess(mol_t_Orders model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update t_Orders set ");
            strSql.Append("opratorId=@opratorId,");
            strSql.Append("PROCESS=@PROCESS,");
            strSql.Append("States=@States ");
            strSql.Append("WHERE Id=@Id ");
            SqlParameter[] parameters = {
					new SqlParameter("@opratorId", SqlDbType.Int,10),
					new SqlParameter("@PROCESS", SqlDbType.VarChar,1000),
					new SqlParameter("@States", SqlDbType.Int,10),
					new SqlParameter("@Id", SqlDbType.Int,10)};
            parameters[0].Value = model.opratorId;
            parameters[1].Value = model.PROCESS;
            parameters[2].Value = model.States;
            parameters[3].Value = model.Id;
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString(), parameters);
            return rows > 0;
        }
    }

    /// <summary>
    /// t_Orders兑换订单 兑换订单数据访问类
    /// </summary>
    public partial class dal_t_Orders
    {
        #region 构造方法
        /// <summary>
        /// 无参构造方法
        /// </summary>
        public dal_t_Orders()
        {
        }
        /// <summary>
        /// 带参构造方法
        /// </summary>
        /// <param name="connectionSetting">配置连接字符串键名</param>
        public dal_t_Orders(string connectionSetting)
        {
            DbHelper.DbHelperSQL.connectionSetting = connectionSetting;
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
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into t_Orders(");
            strSql.Append("opratorId,PROCESS,Email,Postalcode,TellPhone,CreateDate,Cost,UserID,OrderId,States,UserName,AddDress,Cost2,Remarks,Cost1,Rid)  values (");
            strSql.Append("@opratorId,@PROCESS,@Email,@Postalcode,@TellPhone,@CreateDate,@Cost,@UserID,@OrderId,@States,@UserName,@AddDress,@Cost2,@Remarks,@Cost1,@Rid)");
            strSql.Append(";select @@IDENTITY");
            SqlParameter[] parameters = {
					new SqlParameter("@opratorId", SqlDbType.Int,10),
					new SqlParameter("@PROCESS", SqlDbType.VarChar,1000),
					new SqlParameter("@Email", SqlDbType.VarChar,30),
					new SqlParameter("@Postalcode", SqlDbType.VarChar,10),
					new SqlParameter("@TellPhone", SqlDbType.VarChar,15),
					new SqlParameter("@CreateDate", SqlDbType.DateTime,23),
					new SqlParameter("@Cost", SqlDbType.Int,10),
					new SqlParameter("@UserID", SqlDbType.Int,10),
					new SqlParameter("@OrderId", SqlDbType.VarChar,20),
					new SqlParameter("@States", SqlDbType.Int,10),
					new SqlParameter("@UserName", SqlDbType.VarChar,30),
					new SqlParameter("@AddDress", SqlDbType.VarChar,500),
					new SqlParameter("@Cost2", SqlDbType.Int,10),
					new SqlParameter("@Remarks", SqlDbType.VarChar,300),
					new SqlParameter("@Cost1", SqlDbType.Int,10),
					new SqlParameter("@Rid", SqlDbType.Int,10)};
            parameters[0].Value = model.opratorId;
            parameters[1].Value = model.PROCESS;
            parameters[2].Value = model.Email;
            parameters[3].Value = model.Postalcode;
            parameters[4].Value = model.TellPhone;
            parameters[5].Value = model.CreateDate;
            parameters[6].Value = model.Cost;
            parameters[7].Value = model.UserID;
            parameters[8].Value = model.OrderId;
            parameters[9].Value = model.States;
            parameters[10].Value = model.UserName;
            parameters[11].Value = model.AddDress;
            parameters[12].Value = model.Cost2;
            parameters[13].Value = model.Remarks;
            parameters[14].Value = model.Cost1;
            parameters[15].Value = model.Rid;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            if (obj == null)
            {
                return 0;
            }
            else
            {
                return Convert.ToInt32(obj);
            }
        }
        /// <summary>
        /// 获取字段最大值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMaxValue(string sField)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT ISNULL(MAX(");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
                strSql.Append("),0) AS ").Append(sField);
            }
            else
            {
                strSql.Append("Id),0) AS Id");
            }
            strSql.Append(" FROM t_Orders");
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            return Convert.ToInt32(obj);
        }
        /// <summary>
        /// 获取单个字段值
        /// </summary>
        /// <param name="sField">获取该字段值，空则默认主键值</param>
        /// <param name="Id">编号</param>
        /// <returns>object</returns>
        public object GetOneField(string sField, Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT TOP 1 ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id");
            }
            strSql.Append(" FROM t_Orders ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            return obj;
        }
        /// <summary>
        /// 获取字段最小值
        /// </summary>
        /// <param name="sField">获取该字段名称，空则默认主键值</param>
        /// <returns>int</returns>
        public int GetMinValue(string sField)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT ISNULL(MIN(");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
                strSql.Append("),0) AS ").Append(sField);
            }
            else
            {
                strSql.Append("Id),0) AS Id");
            }
            strSql.Append(" FROM t_Orders");
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            return Convert.ToInt32(obj);
        }
        /// <summary>
        /// 删除一条数据
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool Delete(Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("delete from t_Orders ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString(), parameters);
            return rows > 0;
        }
        /// <summary>
        /// 批量删除数据
        /// </summary>
        /// <param name="Ids">编号</param>
        /// <returns>bool</returns>
        public bool DeleteList(string Ids)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("delete from t_Orders ");
            strSql.AppendFormat("WHERE Id IN({0})", Ids);
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString());
            return rows > 0;
        }
        /// <summary>
        /// 获取记录总数
        /// </summary>
        /// <param name="strWhere">查询条件</param>
        /// <returns>bool</returns>
        public int GetRecordCount(string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select count(1) FROM t_Orders WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString());
            if (obj == null)
            {
                return 0;
            }
            else
            {
                return Convert.ToInt32(obj);
            }
        }
        /// <summary>
        /// 是否存在该记录
        /// </summary>
        /// <param name="Id">编号</param>
        /// <returns>bool</returns>
        public bool IsExists(Int32 Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select count(1) from t_Orders ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
				new SqlParameter("@Id", SqlDbType.Int,10)
			};
            parameters[0].Value = Id;
            object obj = DbHelperSQL.OneFieldSql(strSql.ToString(), parameters);
            if ((Object.Equals(obj, null)) || (Object.Equals(obj, System.DBNull.Value)))
            {
                return false;
            }
            else
            {
                return int.Parse(obj.ToString()) > 0;
            }
        }
        /// <summary>
        /// 更新一条数据
        /// </summary>
        /// <param name="model">兑换订单 兑换订单</param>
        /// <returns>bool</returns>
        public bool Update(mol_t_Orders model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update t_Orders set ");
            strSql.Append("opratorId=@opratorId,");
            strSql.Append("PROCESS=@PROCESS,");
            strSql.Append("Email=@Email,");
            strSql.Append("Postalcode=@Postalcode,");
            strSql.Append("TellPhone=@TellPhone,");
            strSql.Append("CreateDate=@CreateDate,");
            strSql.Append("Cost=@Cost,");
            strSql.Append("UserID=@UserID,");
            strSql.Append("OrderId=@OrderId,");
            strSql.Append("States=@States,");
            strSql.Append("UserName=@UserName,");
            strSql.Append("AddDress=@AddDress,");
            strSql.Append("Cost2=@Cost2,");
            strSql.Append("Remarks=@Remarks,");
            strSql.Append("Cost1=@Cost1,");
            strSql.Append("Rid=@Rid ");
            strSql.Append("WHERE Id=@Id");
            SqlParameter[] parameters = {
					new SqlParameter("@opratorId", SqlDbType.Int,10),
					new SqlParameter("@PROCESS", SqlDbType.VarChar,1000),
					new SqlParameter("@Email", SqlDbType.VarChar,30),
					new SqlParameter("@Postalcode", SqlDbType.VarChar,10),
					new SqlParameter("@TellPhone", SqlDbType.VarChar,15),
					new SqlParameter("@CreateDate", SqlDbType.DateTime,23),
					new SqlParameter("@Cost", SqlDbType.Int,10),
					new SqlParameter("@UserID", SqlDbType.Int,10),
					new SqlParameter("@OrderId", SqlDbType.VarChar,20),
					new SqlParameter("@States", SqlDbType.Int,10),
					new SqlParameter("@UserName", SqlDbType.VarChar,30),
					new SqlParameter("@AddDress", SqlDbType.VarChar,500),
					new SqlParameter("@Cost2", SqlDbType.Int,10),
					new SqlParameter("@Remarks", SqlDbType.VarChar,300),
					new SqlParameter("@Cost1", SqlDbType.Int,10),
					new SqlParameter("@Rid", SqlDbType.Int,10),
					new SqlParameter("@Id", SqlDbType.Int,10)};
            parameters[0].Value = model.opratorId;
            parameters[1].Value = model.PROCESS;
            parameters[2].Value = model.Email;
            parameters[3].Value = model.Postalcode;
            parameters[4].Value = model.TellPhone;
            parameters[5].Value = model.CreateDate;
            parameters[6].Value = model.Cost;
            parameters[7].Value = model.UserID;
            parameters[8].Value = model.OrderId;
            parameters[9].Value = model.States;
            parameters[10].Value = model.UserName;
            parameters[11].Value = model.AddDress;
            parameters[12].Value = model.Cost2;
            parameters[13].Value = model.Remarks;
            parameters[14].Value = model.Cost1;
            parameters[15].Value = model.Rid;
            parameters[16].Value = model.Id;
            int rows = DbHelperSQL.ExecuteSql(strSql.ToString(), parameters);
            return rows > 0;
        }
        /// <summary>
        /// 获取实体对象
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>mol_t_Orders</returns>
        public mol_t_Orders GetMOL(string sField, string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(1) ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,opratorId,PROCESS,Email,Postalcode,TellPhone,CreateDate,Cost,UserID,OrderId,States,UserName,AddDress,Cost2,Remarks,Cost1,Rid");
            }
            strSql.Append(" FROM t_Orders WHERE 1=1 ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            SqlDataReader SqlReader = DbHelperSQL.DataReaderSql(strSql.ToString());
            return DbHelperMOL.ReaderToModel<mol_t_Orders>(SqlReader);
        }
        /// <summary>
        /// 获取实体对象集合
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <returns>List mol_t_Orders</returns>
        public List<mol_t_Orders> GetListMOL(string sField, string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,opratorId,PROCESS,Email,Postalcode,TellPhone,CreateDate,Cost,UserID,OrderId,States,UserName,AddDress,Cost2,Remarks,Cost1,Rid");
            }
            strSql.Append(" FROM t_Orders WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            SqlDataReader SqlReader = DbHelperSQL.DataReaderSql(strSql.ToString());
            return DbHelperMOL.ReaderToList<mol_t_Orders>(SqlReader);
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
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(").Append(sTop).Append(") ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,opratorId,PROCESS,Email,Postalcode,TellPhone,CreateDate,Cost,UserID,OrderId,States,UserName,AddDress,Cost2,Remarks,Cost1,Rid");
            }
            strSql.Append(" FROM t_Orders WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(" ORDER BY ");
            if (!string.IsNullOrEmpty(sOrder))
            {
                strSql.Append(sOrder);
            }
            else
            {
                strSql.Append("Id ASC;");
            }
            return DbHelperSQL.DataSetSql(strSql.ToString());
        }
        /// <summary>
        /// SQL表数据分页
        /// </summary>
        /// <param name="sField">查询字段 可为空则全部字段 id,name</param>
        /// <param name="strWhere">查询条件 可为空则全表数据 ID=1 AND NAME=2</param>
        /// <param name="sOrder">排序字段名称 为空默认主键</param>
        /// <param name="PageSize">页大小</param>
        /// <param name="PageIndex">索引页 从1开始计数</param>
        /// <returns>DataSet 两个数据集 数据集1为分页数据，数据集2为总个数</returns>
        public DataSet GetList(string sField, string strWhere, string sOrder, int PageSize, int PageIndex)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append(" SELECT TOP(");
            strSql.Append(PageSize).Append(") ");
            if (!string.IsNullOrEmpty(sField))
            {
                strSql.Append(sField);
            }
            else
            {
                strSql.Append("Id,opratorId,PROCESS,Email,Postalcode,TellPhone,CreateDate,Cost,UserID,OrderId,States,UserName,AddDress,Cost2,Remarks,Cost1,Rid");
            }
            strSql.Append(" FROM t_Orders WHERE Id");
            strSql.Append(" > (SELECT ISNULL(MAX(Id),0) AS Id FROM(SELECT TOP(").Append((PageIndex - 1) * PageSize).Append(") Id FROM t_Orders");
            strSql.Append(" WHERE 1=1");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(" ORDER BY Id ASC) t) ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            strSql.Append(";SELECT COUNT(1) AS total FROM t_Orders WHERE 1=1 ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                strSql.Append(" AND ").Append(strWhere);
            }
            return DbHelperSQL.DataSetSql(strSql.ToString());
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
            SqlParameter[] parameters = {
				new SqlParameter("@TableNames", SqlDbType.VarChar, 200),
				new SqlParameter("@PrimaryKey", SqlDbType.VarChar, 100),
				new SqlParameter("@Fields", SqlDbType.VarChar, 300),
				new SqlParameter("@Filter", SqlDbType.VarChar, 300),
				new SqlParameter("@Group", SqlDbType.VarChar, 200),
				new SqlParameter("@Order", SqlDbType.VarChar, 200),
				new SqlParameter("@PageSize", SqlDbType.Int),
				new SqlParameter("@CurrentPage", SqlDbType.Int)};
            parameters[0].Value = "t_Orders";
            parameters[1].Value = "Id";
            parameters[2].Value = "Id,opratorId,PROCESS,Email,Postalcode,TellPhone,CreateDate,Cost,UserID,OrderId,States,UserName,AddDress,Cost2,Remarks,Cost1,Rid";
            parameters[3].Value = strWhere.ToString();
            parameters[4].Value = "";
            parameters[5].Value = sOrder;
            parameters[6].Value = PageSize;
            parameters[7].Value = PageIndex - 1;
            return DbHelperSQL.DataSetSql("proc_user_page", CommandType.StoredProcedure, parameters);
        }
        #endregion
    }
    #endregion
}