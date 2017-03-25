var WxHelper = (function () {
    var APP_ID = '';
    var APP_SECRET = '';
    var REDIRECT_URI = 'www.gzqy5188.com';
    var REFRESH_TOKEN = '';
    var wx_code_url = 'https://open.weixin.qq.com/connect/qrconnect?appid=#APPID#&redirect_uri=#REDIRECT_URI#&response_type=#RESPONSE_TYPE#&scope=#SCOPE#&state=#STATE#';
    var wx_token_url = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid=#APPID#&secret=#SECRET#&code=#CODE#&grant_type=#GRANT_TYPE#';
    var wx_refreshtoken_url = 'https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#APPID#&grant_type=#GRANT_TYPE#&refresh_token=#REFRESH_TOKEN#';
    var wx_userinfo_url = 'https://api.weixin.qq.com/sns/userinfo?access_token=#ACCESS_TOKEN&openid=##&scope=#SCOPE#';

    function Get(url, succFunc) {
        $.getJSON(url).done(function (res) {
            succFunc(res);
        }).fail(function (err) {
            alert(err.responseText);
        });
    }

    return {
        LoadRefreshToken: function () {
            REFRESH_TOKEN = '';
        },
        GetCodeUrl: function () {
            return wx_code_url.replace('#APPID#', APP_ID)
                             .replace('#REDIRECT_URI#', REDIRECT_URI)
                             .replace('#RESPONSE_TYPE#', 'code')
                             .replace('#SCOPE#', 'snsapi_login')
                             .replace('#STATE#', 'qywl');
        },
        GetToken: function (code, cb) {
            var url = wx_token_url.replace('#APPID#', APP_ID)
                                .replace('#SECRET#', APP_SECRET)
                                .replace('#CODE#', code)
                                .replace('#GRANT_TYPE#', 'authorization_code');
            Get(url, function (res) {
            });
        },
        RefreshToken: function () {
            var url = wx_refreshtoken_url.replace('#APPID#', APP_ID)
                                        .replace('#GRANT_TYPE#', 'refresh_token')
                                        .replace('#REFRESH_TOKEN#', REFRESH_TOKEN);
            Get(url, function (res) {
            });
        },
        GetWxUserInfo: function (access_token) {
            var url = wx_refreshtoken_url.replace('#ACCESS_TOKEN#', access_token)
                                        .replace('#SCOPE#', 'snsapi_base')
                                        .replace('OPENID', OPENID);
            Get(url, function (res) {
            });
        }
    }
})();