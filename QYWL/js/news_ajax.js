// JavaScript Document
$(function () {
    function News() {
        dd.Get('/News/HotNewList', null,
            function (data) {
                var news = data.message;
                for (var i in news) {
                    var item = news[i];
                    var NewsList = '<li><a href="html/news_article.html?id=' + item.NewsID + '">' +
                                         '<span class="article">' + item.Subject + '</span>' +
                                         '<span class="date">' + item.IssueDate + '</span>' +
                                        '</a></li>';
                    var NewsList_News = '<li><a href="news_article.html?id=' + item.NewsID + '">' +
											'<span class="NewsName">' + item.ClassID + '</span>' +
											'<span class="NewsTitles">' + item.Subject + '</span>' +
											'<span class="NewsDate">' + item.IssueDate + '</span>' +
										'</a></li>'
                    if (item.ClassID == 1) {
                        $('.News .NewsContent ul:eq(0)').append(NewsList);
                        $('.NewsArticleName ul:eq(1)').append(NewsList_News)
                    } else if (item.ClassID == 2) {
                        $('.News .NewsContent ul:eq(1)').append(NewsList);
                        $('.NewsArticleName ul:eq(0)').append(NewsList_News)
                    }
                }
            }, function (err) {
                alert('请求失败');
            });
    }
    News();
})