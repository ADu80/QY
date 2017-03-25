// JavaScript Document
$(function () {
    function hover(e, position) {
        $(e.target).addClass('current').siblings().removeClass('current');
        $(e.target).children('dt').children('img').eq(0).css({ display: "none" })
        $(e.target).children('dt').children('img').eq(1).css({ display: "block" })
        $(e.target).children("dd").children("p").css({ "background-position": "0 -" + position + "px" })
    }
    function hover2(e, position) {
        $(e.target).children('dt').children('img').eq(1).css({ display: "none" })
        $(e.target).children('dt').children('img').eq(0).css({ display: "block" })
        $(e.target).children("dd").children("p").css({ "background-position": "0 -" + position + "px" })
    }

    dd.Get('/GameGameItem/GetDownload', null,
        function (data) {
            var arr = data.message;
            $.each(arr, function (index, el) {
                if (el.ImgUrl) {
                    var gameList = '<dl id="' + el.GameID + '">' +
                                    '<dt>' +
                                        '<img src="../' + el.ImgUrl + '" width="166"alt=""/>' +
                                        '<img src="data:image/png;base64,' + el.ORCodeAddr + '" width="166"alt=""/>' +
                                    '</dt>' +
                                    '<dd>' +
                                        '<h3>' + el.GameName + '</h3>' +
                                        '<a id="' + el.GameID + '">详情</a>' +
                                    '</dd>' +
                                 '</dl>';
                    $('.AboutAdroid .myGameContent.mygame1').append(gameList);
                    //下载专区的二维码切换
                    //$('.AboutAdroid .DownloadGameContent dl').hover(function (e) {
                    //    hover(e, 390);
                    //}, function (e) {
                    //    hover2(e, 419);
                    //});
                    //$('.AboutIOS .DownloadGameContent dl').hover(function (e) {
                    //    hover(e, 390);
                    //}, function (e) {
                    //    hover2(e, 419);
                    //});
                    //点击下载弹出下载框
                    $('.myGame .myGameContent a').click(function (e) {
                        var id = $(this).attr("id");
                        if (el.GameID == id) {
                            var GameDetailsList = '<div class="GameDetails">' +
                                                    '<div class="GameDetailsTop">' +
                                                        '<p>' + el.GameName + 'Android版下载</p>' +
                                                        '<span></span>' +
                                                    '</div>' +
                                                    '<div class="GameDetailsContent">' +
                                                        '<dl>' +
                                                            '<dt><img src="../' + el.ImgUrl + '" width="134" alt=""></dt>' +
                                                            '<dd>' +
                                                                '<h2 class="GamesTitle">' + el.GameName + '</h2>' +
                                                                '<p class="GamesInformation">版本：V4.06.08 大小：42M 更新：2016-11-28</p>' +
                                                                '<p class="DetailsArticle">' + el.GameDes + '</p>' +
                                                            '</dd>' +
                                                        '</dl>' +
                                                        '<div class="GameDetails_DownLeft">' +
                                                            '<h3>下载到电脑</h3>' +
                                                            '<p>下载apk文件，通过数据线或读卡器传输到手机内存卡中在文件管理器里执行安装</p>' +
                                                            '<a class="GameDownloadNow" href="' + el.DownLoadAddr + '"></a>' +
                                                        '</div>' +
                                                        '<div class="GameDetails_DownRight">' +
                                                            '<h3>拍摄二维码</h3>' +
                                                            '<p>使用手机上的二维码扫描软件以下二维码即可下载</p>' +
                                                            '<img src="' + el.ORCodeAddr + '" width="120" alt="">' +
                                                        '</div>' +
                                                        '<div class="GameDetails_BigImg"><img src="' + el.ORCodeAddr + '" width="300" alt=""></div>'
                                                    '</div>' +
                                                '</div>';
                            $('.GameDetails_Wrapper').append(GameDetailsList);
                            $('.GameDetails_Wrapper .GameDetails_DownRight img').hover(function (e) {
                                $('.GameDetails_Wrapper .GameDetails_BigImg').show();
                            }, function (e) {
                                $('.GameDetails_Wrapper .GameDetails_BigImg').hide();
                            });
                        }
                        $('.GameDetails_Wrapper').css({ display: 'block' });
                        $('.GameDetails .GameDetailsTop span').click(function (e) {
                            $('.GameDetails_Wrapper').css({ display: 'none' })
                        });
                    });
                }
            });
        }, function (err) {
            alert('请求失败！')
        });
});