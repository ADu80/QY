// JavaScript Document
$(function () {
    var qs = getQueryString();
    var data = 'id=' + qs["id"];

    dd.Get('/News/NewDetailList', data,
        function (data) {
            var el = data.message[0];
            var titleList, authorList, artileList, nextList;
            titleList = '<h3 class="NewsArticleTitle">' + el.Subject + '</h3>';//标题
            authorList = '<p class="NewsAbout">' +   // 作者和时间
                            '<span class="ArticleAuthor">' + el.UserID + '</span>' +
                            '<span class="ArticleTime">' + el.IssueDate + '</span>' +
                        '</p>';
            artileList = '<div class="ArticleShow">' + el.Body + '</div>'  //  正文
            /*						nextList='<p class="NextBox"><a href="#">上一篇：'+ el.Subject  +'</a><a href="#">下一篇：'+ el.Subject  +'</a></p>';				//	下一篇和上一篇
            */
            $('.NewsArticleContent').append(titleList + authorList + artileList);
            //return;
        },
        function (err) {
            alert('请求失败')
        }
    );
})
