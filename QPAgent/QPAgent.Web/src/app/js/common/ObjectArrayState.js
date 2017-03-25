var ArrayState = (function () {
    function indexOf(arr, ele, key) {
        for (var i = 0, len = arr.length; i < len; i++) {
            if (arr[i][key] === ele[key]) {
                return i;
            }
        }
        return -1;
    }
    return {
        indexOf: indexOf
    }
})();