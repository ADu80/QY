//验证封装
var ValidateState = ValidateState || (function () {
    var _code;
    var _validArr = [];
    function createCode() {
        _code = "";
        var codeLength = 6; //验证码的长度
        var codeChars = new Array(1, 2, 3, 4, 5, 6, 7, 8, 9,
             'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
             'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'); //所有候选组成验证码的字符，当然也可以用中文的
        var len = codeChars.length;
        for (var i = 0; i < codeLength; i++) {
            var charNum = Math.floor(Math.random() * len);
            _code += codeChars[charNum];
        }
        return _code;
    }
    function validateCode(inputCode) {
        var r = { status: true, msg: "" };
        if (inputCode.length <= 0) {
            r = { status: false, msg: "请输入验证码！" };
        }
        else if (inputCode.toUpperCase() != _code.toUpperCase()) {
            //createCode();
            r = { status: false, msg: "验证码输入有误！" };
        }
        else {
            r = { status: true, msg: "" };
        }
        return r;
    }
    function chechlength(val, validLength) {
        return val.length >= validLength;
    }
    function checkuser(val) {
        var regx = /[\w\u4E00-\u9FA5\uF900-\uFA2D]{3,20}/;
        var t = regx.test(val);
        return { status: t, msg: (t ? '' : '用户名格式不正确，只能由3-20个中文、大小写字母或下划线组成！') };
    }
    function checkpassword(val) {
        var regx = /[\w\S]{6,20}/;//密码可以包含非空字符、字母数字下划线，长度大于等于6，小于等于20
        var t = regx.test(val);
        return { status: t, msg: (t ? '' : '密码不能包含空格，长度不少6，不超过20') };
    }
    function indexOf(arr, key) {
        for (var i = 0, len = arr.length; i < len; i++) {
            if (arr[i].key === key) {
                return i;
            }
        }
        return -1;
    }
    function pushValidateItem(key, bvalue, msg) {
        var index = indexOf(_validArr, key);
        if (index == -1) {
            _validArr.push({ key: key, bvalue: bvalue, message: msg });
        }
        else {
            _validArr[index].bvalue = bvalue;
            _validArr[index].message = msg;
        }
    }
    function validateAll() {
        var count = 0;
        var msg = '';
        for (var i = 0, len = _validArr.length; i < len; i++) {
            if (_validArr[i].bvalue) {
                count++;
            }
            else {
                msg += _validArr[i].message + '\n';
            }
        }
        if (count == _validArr.length)
            return { status: true, msg: '' };
        return { status: false, msg: msg };
    }
    return {
        createCode: function () {
            return createCode();
        },
        validateCode: function (code) {
            return validateCode(code);
        },
        checkuser: function (val) {
            return checkuser(val);
        },
        checkpassword: function (val) {
            return checkpassword(val);
        },
        chechlength: function (val, validLength) {
            return chechlength(val, validLength);
        },
        pushValidateItem: function (key, bvalue, msg) {
            pushValidateItem(key, bvalue, msg);
        },
        validateAll: function () {
            return validateAll();
        }
    }
})();