<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="introduce.aspx.cs" Inherits="Game.Web.Introduce.introduce" %>

<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>广州棋游-公司简介</title>
    <link href="/style/Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <%--<link href="/style/global_new.css" rel="stylesheet" />--%>
    <link href="/style/company.css" rel="stylesheet" />
    <script src="/style/Bootstrap/js/jquery-3.1.1.min.js"></script>
    <script src="/style/Bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
    <nav class="header navbar navbar-inverse" role="navigation">
        <div><a href="/Default.aspx" class="backwww">返回游戏官网</a></div>
        <div class="container-fluid container">
            <div class="navbar-header">
                <a class="navbar-brand" href="/Introduce/Company.aspx">关于我们</a>
            </div>
            <div>
                <ul class="nav navbar-nav">
                    <li><a href="/Introduce/introduce.aspx">公司简介</a></li>
                    <li><a href="/Introduce/events.aspx">活动风采</a></li>
                    <li><a href="/Introduce/contact.aspx">联系我们</a></li>
                    <li><a href="/Introduce/recruit.aspx">招聘信息</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="webpath">
        <ol class="breadcrumb container">
            <li><a href="/Introduce/Company.aspx">关于我们</a></li>
            <li class="active">公司简介</li>
        </ol>
    </div>
    <div class="content graybg">
        <article class="container">
            <h3>公司简介</h3>
            <p>
                瓜迪奥拉希望执教阿根廷，想必和梅西的存在不无关系，而且阿根廷众星云集，有大批技术型选手，符合瓜迪奥拉执教的理念。另外，阿根廷作为世界足坛的顶尖豪强之一，已经有近30年未曾染指大赛冠军（上次夺冠是1993年美洲杯），而如能带队拿下阔别30年的世界杯（阿根廷上次夺冠是1986年），更将是一个极大的成就。
　　不过，即便瓜迪奥拉有意执教阿根廷，时机依然是最大的阻碍，他如今在曼城干得风生水起，近期内恐怕不会另作他谋，而2018年俄罗斯世界杯已经迫近，能否赶得上是个大问题，除非阿根廷足协和曼城达成一致，能让瓜帅兼顾带队（例如希丁克在埃因霍温时曾兼职带澳大利亚打进06世界杯淘汰赛），否则梅西冲击世界杯的最后黄金期（2018年梅西31岁），瓜迪奥拉恐怕就会错过了。
　　另外，阿圭罗还谈到了瓜迪奥拉平日带队的一些情况。“我不知道他抓到了谁在玩手机，结果他下令把网络全断了。”
            </p>
        </article>
        <article class="container">
            <h3>文化理念</h3>
            <p>
                迎接变化，勇于创新<br />
                适应公司的日常变化，不抱怨<br />
                面对变化，理性对待，充分沟通，诚意配合<br />
                在工作中有前瞻意识，建立新方法，新思路<br />
                创造变化，并带来绩效突破性地提高<br />
                勇于承认错误，敢于承担责任<br />
                激情--乐观向上，永不言弃<br />
                热爱工作，顾全大局，不计较个人得失<br />
                以积极乐观的心态面对日常工作，不断自我激励，并获得成功<br />
                不断设定更高的目标，今天的最好变现是明天的最低要求<br />
                敬业--专业执着，精益求精<br />
                上班时间只做与工作有关的事情，没有因工作失职而造成的重复错误<br />
                今天的事不推到明天，遵循必要的工作流程<br />
                持续学习，自我完善，做事情充分体现以结果为导向<br />
                得客户者得天下<br />
                产品与产品的差异在于细节<br />
                以人才和技术为基础，创造最佳产品和服务<br />
                人才第一，追求一流，引领变革，正道经营，共存共赢<br />
                企业文化宣传口号，企业文化标语，公司文化标语口号 
                <br />
            </p>
        </article>
    </div>

    <qp:Footer ID="sFooter" runat="server" />

    <script src="/js/levan.introduce.js"></script>
</body>
</html>
