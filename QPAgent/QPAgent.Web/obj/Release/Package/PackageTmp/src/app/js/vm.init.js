(function () {
    function initcb() {
        //if (!app.LoginUser.IsAgent) {
        //    vmadmin.init();
        //    vmroles.init();
            vmspreaderoptions.init();
        //    vmsensitiveword.init();
        //}
        vmMenu.init();
        vmInfo.init();
        //vmsubagentlist.init();
        //vmlog.init();
    }
    app.init(initcb);
})();