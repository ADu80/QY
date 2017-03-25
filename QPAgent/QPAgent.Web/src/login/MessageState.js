var MessageState = (function () {
    var msgInterval;
    function Show(dom, msg) {
        $(dom).text(msg);
        $(dom).css({ color: '#f22' });
        if (msgInterval) {
            clearInterval(msgInterval);
        }
        msgInterval = setInterval(function () {
            $(dom).text('');
        }, 3000)
    }
    return {
        Show: function (dom, msg) {
            Show(dom, msg)
        }
    }
})();
