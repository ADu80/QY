var ArrayState = (function () {
    function indexOf(arr, ele) {
        for (var i = 0, len = arr.length; i < len; i++) {
            if (arr[i] === ele) {
                return i;
            }
        }
        return -1;
    }
    return {
        indexOf: indexOf
    }
})();