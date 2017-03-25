// JavaScript Document
$(function () {
    dd.Get('/GameGameItem/HotGameList', null,
        function (data) {
            var arr = data.message;
            $.each(arr, function (index, el) {
                if (el.ImgUrl) {
                    GameList = '<dl>' +
                                    '<dt><img src="' + el.ImgUrl + '" width="166" alt=""/></dt>' +
                                    '<dd>' +
                                        '<h3>' + el.GameName + '</h3>' +
                                        '<p><a href="html/Download_ToPhone.html" style="display:block;height:100%;" target="_blank"></a></p>' +
                                    '</dd>' +
                                '</dl>';
                    console.log(el.ImgUrl);
                    $('.myGame .myGameContent').append(GameList);
                    $('.myGame .myGameContent dl:gt(9)').css("display", "none");
                    if (window.screen.width > 980) {
                        if (el.ImgUrl == 'images/game_not.png') {
                            var num = index;
                            $('.myGame .myGameContent dl').eq(num).addClass('not');
                        } else if (el.ImgUrl != 'images/game_not.png') {
                            var num = index;
                            if (window.screen.width > 980) {
                                $('.myGame .myGameContent dl').hover(function (e) {
                                    $(this).children("dd").children("h3").css({ color: '#ff7800' })
                                    $(this).children("dd").children("p").css({ "background-position": "0 -390px" })
                                }, function () {
                                    $(this).children("dd").children("h3").css({ color: '#555' })
                                    $(this).children("dd").children("p").css({ "background-position": "0 -419px" })
                                })
                            }
                        }
                    }
                }
            });
        },
        function (err) {
            console.log(err);
            alert('请求失败！');
        }
    );
})






