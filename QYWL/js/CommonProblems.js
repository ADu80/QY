// JavaScript Document
$(function () {
    var querystringObj = getQueryString();
    var id = querystringObj['id'];
    dd.Get('/News/GameIssueInfoList', null, function (data) {
        var Problems = new Array();
        var arr = data.message;
        $.each(arr, function (index, el) {
            var ProblemsList = '<li id="' + el.IssueID + '">' + el.IssueTitle + '</li>'  //这个是左边的tab栏
            $('.HelpCenterBox .CommonProblems ul').append(ProblemsList);
            $('.HelpCenterBox .CommonProblems li').click(function () {
                var id = this.id;
                $(this).addClass('color').siblings().removeClass('color');
                $(".CommonProblems_article").html('');
                var CommonProblems_articleList = '<h3>' + el.IssueTitle[index] + '</h3>' +	//这里是右边显示的内容区
                                                '<p>' + el.IssueContent[index] + '</p>'
                $('.CommonProblems_article').append(CommonProblems_articleList);
            });
        });
    }, function (err) {
        alert('请求失败！');
    });
});

