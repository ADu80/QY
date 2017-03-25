using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QPNativeWebDB.DbHelper
{
    public class DbHelperSQL
    {
        public static int ExecuteSql(string cmdText, CommandType cmdType, params SqlParameter[] cmdParms)
        {
            using (SqlConnection conn = new SqlConnection(connectionSetting))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    try
                    {
                        PrepareCommand(cmd, conn, null, cmdType, cmdText, cmdParms);
                        return cmd.ExecuteNonQuery();
                    }
                    catch (SqlException e)
                    {
                        conn.Close();
                        throw new Exception(e.Message);
                    }
                }
            }
        }
        public static int ExecuteSql(string sql, SqlParameter[] cmdParms)
        {
            return ExecuteSql(sql, CommandType.Text, cmdParms);
        }
        public static int ExecuteSql(string cmdText)
        {
            return ExecuteSql(cmdText, null);
        }
        public static int ExecuteTranSql(string cmdText, CommandType cmdType, params SqlParameter[] cmdParms)
        {
            using (SqlConnection conn = new SqlConnection(connectionSetting))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    conn.Open();
                    SqlTransaction trans = conn.BeginTransaction();
                    try
                    {
                        PrepareCommand(cmd, conn, trans, cmdType, cmdText, cmdParms);
                        int result = cmd.ExecuteNonQuery();
                        trans.Commit();
                        return result;
                    }
                    catch (SqlException e)
                    {
                        trans.Rollback();
                        conn.Close();
                        throw new Exception(e.Message);
                    }
                }
            }
        }
        public static int ExecuteTranSql(string cmdText, SqlParameter[] cmdParms)
        {
            return ExecuteTranSql(cmdText, CommandType.Text, cmdParms);
        }
        public static int ExecuteTranSql(string cmdText)
        {
            return ExecuteTranSql(cmdText, null);
        }
        public static object OneFieldSql(string cmdText, CommandType cmdType, params SqlParameter[] cmdParms)
        {
            using (SqlConnection conn = new SqlConnection(connectionSetting))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    try
                    {
                        PrepareCommand(cmd, conn, null, cmdType, cmdText, cmdParms);
                        return cmd.ExecuteScalar();
                    }
                    catch (SqlException e)
                    {
                        conn.Close();
                        throw new Exception(e.Message);
                    }
                }
            }
        }
        public static object OneFieldSql(string cmdText, SqlParameter[] cmdParms)
        {
            return OneFieldSql(cmdText, CommandType.Text, cmdParms);
        }
        public static object OneFieldSql(string cmdText)
        {
            return OneFieldSql(cmdText, null);
        }
        public static bool Exists(string cmdText, SqlParameter[] cmdParms)
        {
            object obj = OneFieldSql(cmdText, cmdParms);
            int cmdresult;
            if ((Object.Equals(obj, null)) || (Object.Equals(obj, System.DBNull.Value)))
            {
                cmdresult = 0;
            }
            else
            {
                cmdresult = Convert.ToInt32(obj);
            }
            if (cmdresult == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        public static DataSet DataSetSql(string cmdText, CommandType cmdType, params SqlParameter[] cmdParms)
        {
            using (SqlConnection conn = new SqlConnection(connectionSetting))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    try
                    {
                        PrepareCommand(cmd, conn, null, cmdType, cmdText, cmdParms);
                        using (SqlDataAdapter dp = new SqlDataAdapter())
                        {
                            dp.SelectCommand = cmd;
                            DataSet ds = new DataSet();
                            dp.Fill(ds);
                            return ds;
                        }
                    }
                    catch (SqlException e)
                    {
                        throw new Exception(e.Message);
                    }
                }
            }
        }
        public static DataSet DataSetSql(string cmdText, SqlParameter[] cmdParms)
        {
            return DataSetSql(cmdText, CommandType.Text, cmdParms);
        }
        public static DataSet DataSetSql(string cmdText)
        {
            return DataSetSql(cmdText, null);
        }
        public static DataView DataViewSql(string cmdText, SqlParameter[] cmdParms, int dsIndex)
        {
            return DataSetSql(cmdText, cmdParms).Tables[dsIndex].DefaultView;
        }
        public static DataView DataViewSql(string cmdText)
        {
            return DataViewSql(cmdText, null, 0);
        }
        public static SqlDataReader DataReaderSql(string cmdText, CommandType cmdType, params SqlParameter[] cmdParms)
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                SqlConnection conn = new SqlConnection(connectionSetting);
                try
                {
                    PrepareCommand(cmd, conn, null, cmdType, cmdText, cmdParms);
                    return cmd.ExecuteReader(CommandBehavior.CloseConnection);
                }
                catch (SqlException e)
                {
                    conn.Close();
                    throw new Exception(e.Message);
                }
            }
        }
        public static SqlDataReader DataReaderSql(string cmdText, SqlParameter[] cmdParms)
        {
            return DataReaderSql(cmdText, CommandType.Text, cmdParms);
        }
        public static SqlDataReader DataReaderSql(string cmdText)
        {
            return DataReaderSql(cmdText, CommandType.Text, null);
        }
        public static string ToSafeString(string str)
        {
            if (string.IsNullOrEmpty(str))
            {
                return str;
            }
            return str.Replace("'", "''").Replace("-", "[-]").Replace("%", "[%]");
        }
        public static string ToSimpleSafe(string str)
        {
            if (string.IsNullOrEmpty(str))
            {
                return str;
            }
            return str.Replace("'", "''");
        }
        private static string _connectionSetting;
        public static string connectionSetting
        {
            get
            {
                if (string.IsNullOrEmpty(_connectionSetting))
                {
                    return ConfigurationManager.AppSettings["connectionSetting"];
                }
                return _connectionSetting;
            }
            set { _connectionSetting = ConfigurationManager.AppSettings[value]; }
        }
        private static void PrepareCommand(SqlCommand cmd, SqlConnection conn, SqlTransaction trans, CommandType cmdType, string cmdText, params SqlParameter[] cmdParms)
        {
            if (conn.State != ConnectionState.Open)
            {
                conn.Open();
            }
            cmd.Connection = conn;
            cmd.CommandText = cmdText;

            if (trans != null)
            {
                cmd.Transaction = trans;
            }

            cmd.CommandType = cmdType;

            if (cmdParms != null)
            {
                cmd.Parameters.AddRange(cmdParms);
            }
        }
    }
}
