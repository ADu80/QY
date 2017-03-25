var vmMenu = avalon.define({
    $id: 'menu',
    datasource: [],
    menuArr: [],
    submenuArr: [],
    selectedItem: '',
    selectedItemIndex: 0,
    init: function (e) {
        vmMenu.loadViews(app.LoginUser.IsAgent);
        vmMenu.getMenus();
    },
    viewdata: {
        admin: [{ id: 1, title: '代理管理', sid: '', href: '#', view: '', vm: '', hasdetail: false, ico: 'icon-daili', parentId: 0, active: false, open: true, animation: 'enter' },
            { id: 101, title: '代理信息', sid: 'info', href: '#!/info', view: 'info.html', vm: 'vminfo', hasdetail: false, ico: 'levan.ico', parentId: 1, active: false, module: 1 },
            { id: 102, title: '代理商帐号', sid: 'subagentlist', href: '#!/subagentlist', view: 'subagentlist.html', vm: 'vmsubagentlist', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 2 },
            { id: 103, title: '管理员帐号', sid: 'admin', href: '#!/admin', view: 'admin.html', vm: 'vmadmin', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 3 },
            { id: 104, title: '角色管理', sid: 'roles', href: '#!/roles', view: 'roles.html', vm: 'vmroles', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 4 },
            { id: 105, title: '返利配置', sid: 'spreaderoptions', href: '#!/spreaderoptions', view: 'spreaderoptions.html', vm: 'vmspreaderoptions', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 5 },
            { id: 2, title: '系统管理', sid: '', href: '#', view: '', vm: '', hasdetail: false, ico: 'icon-setting', parentId: 0, active: false, open: true, animation: 'enter' },
            { id: 201, title: '操作日志', sid: 'log', href: '#!/log', view: 'log.html', vm: 'vmlog', hasdetail: false, ico: 'levan.ico', parentId: 2, active: false, module: 6 },
            { id: 202, title: '敏感词过滤', sid: 'sensitiveword', href: '#!/sensitiveword', view: 'sensitiveword.html', vm: 'vmsensitiveword', hasdetail: false, ico: 'levan.ico', parentId: 2, active: false, module: 7 }
        ],
        agent: [{ id: 1, title: '代理管理', sid: '', href: '#', view: '', vm: '', hasdetail: false, ico: 'icon-daili', parentId: 0, active: false, open: true, animation: 'enter' },
            { id: 101, title: '代理信息', sid: 'info', href: '#!/info', view: 'info.html', vm: 'vminfo', hasdetail: false, ico: 'levan.ico', parentId: 1, active: false, module: 1 },
            { id: 102, title: '代理商帐号', sid: 'subagentlist', href: '#!/subagentlist', view: 'subagentlist.html', vm: 'vmsubagentlist', hasdetail: true, ico: 'levan.ico', parentId: 1, active: false, module: 2 },
            { id: 103, title: '操作日志', sid: 'log', href: '#!/log', view: 'log.html', vm: 'vmlog', hasdetail: false, ico: 'levan.ico', parentId: 1, active: false, module: 6 },
        ]
    },
    loadViews: function (isagent) {
        if (isagent) {
            vmMenu.datasource = vmMenu.viewdata.agent;
        }
        else {
            vmMenu.datasource = vmMenu.viewdata.admin;
        }
    },
    getMenus: function () {
        if (vmMenu.menuArr.$model.length === 0) {
            vmMenu.menuArr.clear();
            var ms = [];
            var dsm = vmMenu.datasource.$model;
            for (var i = 0, len = dsm.length; i < len; i++) {
                var v = dsm[i];
                if (v.parentId === 0) {
                    ms.push(v);
                }
            };
            vmMenu.menuArr = ms;
        }
    },
    subMenuFilter: function (el) {
        
    },
    showSubMenu: function (m) {
        m.animation = m.animation !== 'leave' ? 'leave' : 'enter';
    },
    getSubmenus: function (pid) {
        var sms = [];
        var dsm = vmMenu.datasource.$model;
        for (var i = 0, len = dsm.length; i < len; i++) {
            var v = dsm[i];
            if (v.parentId === pid) {
                sms.push(v);
            }
        };
        return sms;
    },
    onSelect: function (item) {
        var dsm = vmMenu.datasource.$model;
        var currIndex;

        for (var i = 0, len = dsm.length; i < len; i++) {
            var v = dsm[i];
            if (v.sid == item.sid) {
                currIndex = i;
            }
        };

        vmMenu.datasource[vmMenu.selectedItemIndex].active = false;
        vmMenu.datasource[currIndex].active = true;

        //item.active = true;
        vmMenu.selectedItem = item;
        vmMenu.selectedItemIndex = currIndex;

        //填充数据到右边tab数组
        vmView.changeViewsTab(item);

        var getsid = item.sid;
        if (getsid == "subagentlist") {
            vmsubagentlist.findNew();
        }
        if (getsid == "admin") {
            vmadmin.findNew();
        }
        if (getsid == "roles") {
            vmroles.findNew();
        }
        if (getsid == "log") {
            vmlog.findNew();
            vmlog.getOperations();
        }
        if (getsid == "sensitiveword") {
            vmsensitiveword.findNew();
        }
         
    },
    toggle: false,
    toggleClass: function () {
        vmMenu.toggle = !vmMenu.toggle;
        if (vmView.toggleClass) {
            vmView.toggleClass();
        }
    }
});
