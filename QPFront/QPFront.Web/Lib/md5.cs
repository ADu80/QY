using System.Security.Cryptography;
using System.Text;

/// <summary>
///md5 的摘要说明
/// </summary>
public class md5
{
    public md5()
    {
        //
        //TODO: 在此处添加构造函数逻辑
        //
    }

    public static string MD5(string strToEncrypt)
    {
        return MD5(strToEncrypt, "gb2312");
    }

    /// <summary>
    /// MD5
    /// </summary>
    /// <param name="strToEncrypt"></param>
    /// <returns></returns>
    public static string MD5(string strToEncrypt, string encodeing)
    {
        byte[] bytes = Encoding.GetEncoding(encodeing).GetBytes(strToEncrypt); //.Default.GetBytes(strToEncrypt);

        bytes = new MD5CryptoServiceProvider().ComputeHash(bytes);
        string encryptStr = "";
        for (int i = 0; i < bytes.Length; i++)
        {
            encryptStr = encryptStr + bytes[i].ToString("x").PadLeft(2, '0');
        }
        return encryptStr;
    }
}
