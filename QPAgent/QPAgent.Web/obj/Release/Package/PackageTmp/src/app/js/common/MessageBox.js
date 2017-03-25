var MessageBox = (function () {
    var canAlert = true;
    return {
        show: function (data) {
            if (data.status == 'success') {
                alert(data.message);
            }
            else{
                alert(data.message);
            }
            if (data.expire) {
                window.location.href = '/Login.aspx';
                return false;
            }
        },
        success: function (data) {
            if (data.expire) {
                if (canAlert) {
                    alert(data.message);
                    canAlert = false;
                }
                window.location.href = '/Login.aspx';
                return false;
            }
        },
        error: function (errText) {
            alert(errText);
        },
        none: function (errText) {

        }
    }
})();