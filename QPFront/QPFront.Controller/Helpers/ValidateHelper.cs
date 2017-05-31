using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
/// <summary>
///创建验证码
/// </summary>
public class YZMHelper
{
    /// <summary>
    /// 生成随机字符串
    /// </summary>
    /// <param name="codeCount"></param>
    /// <returns></returns>
    public string CreateRandomCode(int codeCount)
    {
        string randomCode = "";
        try
        {
            string allChar = "2,3,4,5,6,7,H,J,K,L,M,N,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,m,n,p,q,P,Q,R,S,T,U,V,W,r,s,t,u,v,8,9,A,B,C,D,E,F,G,w,x,y,z";
            //按 ,号拆分字符串
            string[] allCharArray = allChar.Split(',');

            int temp = -1;
            Random rand = new Random();
            for (int i = 0; i < codeCount; i++)
            {
                if (temp > 0)
                {
                    rand = new Random(1 * temp * ((int)DateTime.Now.Ticks));
                }
                int t = rand.Next(35);
                if (temp == t)
                {
                    return CreateRandomCode(codeCount);
                }
                temp = t;
                randomCode += allCharArray[t];
            }
        }
        catch (Exception)
        {

        }

        return randomCode;
    }
    /// <summary>
    /// 创建验证码图片,并保存
    /// </summary>
    /// <param name="validateCode"></param>
    /// <returns></returns>
    public void SaveValidateGraphic(string validateCode, string path)
    {
        byte[] buffer = CreateValidateGraphic(validateCode);
        MemoryStream ms2 = new MemoryStream(buffer, 0, buffer.Length);
        ms2.Seek(0, SeekOrigin.Begin);
        System.Drawing.Image image2 = System.Drawing.Image.FromStream(ms2);
        image2.Save(path + "x.jpg", ImageFormat.Jpeg);
    }

    public string GetValidateGraphicBase64String(string code)
    {
        byte[] buffer = CreateValidateGraphic(code);
        var str = "\"data:image/png;base64," + Convert.ToBase64String(buffer) + "\"";
        return str;
    }

    /// <summary>
    /// 创建验证码图片
    /// </summary>
    /// <param name="validateCode"></param>
    /// <returns></returns>
    public byte[] CreateValidateGraphic(string validateCode)
    {
        //设置图片的宽度与高度
        Bitmap image = new Bitmap((int)Math.Ceiling(validateCode.Length * 16.0), 28);
        Graphics g = Graphics.FromImage(image);
        try
        {
            //生成随机生成器
            Random random = new Random();
            //清空图片背景色
            g.Clear(Color.White);
            //图片的干扰线
            for (int i = 0; i < 50; i++)
            {
                int x1 = random.Next(image.Width);
                int x2 = random.Next(image.Width);
                int y1 = random.Next(image.Width);
                int y2 = random.Next(image.Width);
                g.DrawLine(new Pen(Color.Silver), x1, y1, x2, y2);

            }
            Font font = new Font("Arial", 13, (FontStyle.Bold | FontStyle.Italic));
            LinearGradientBrush brush = new LinearGradientBrush(new Rectangle(0, 0, image.Width, image.Height), Color.Blue, Color.DarkRed, 1.2f, true);
            g.DrawString(validateCode, font, brush, 3, 2);
            //画图片的前景干扰点
            for (int i = 0; i < 100; i++)
            {
                int x = random.Next(image.Width);
                int y = random.Next(image.Height);
                image.SetPixel(x, y, Color.FromArgb(random.Next()));
            }
            //画图片的干扰线
            g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);
            //保存图片数据
            MemoryStream stream = new MemoryStream();
            image.Save(stream, ImageFormat.Jpeg);
            //输出图片流
            return stream.ToArray();
        }
        finally
        {
            g.Dispose();
            image.Dispose();
        }
    }
}