var vmView = avalon.define({
    $id: 'view',
    viewtabs: [],
    onSelect: function (i, vt) {
        if (vmView.selectedTab.sid !== vt.sid) {
            var preIndex = vmView.selectedTabIndex;
            var currIndex = i;

            vmView.viewtabs[preIndex].active = false;
            vmView.viewtabs[currIndex].active = true;
            var newVt = vt.$model;
            newVt.active = true;
            vmView.selectedTab = newVt;
            vmView.selectedTabIndex = currIndex;
        }
    },
    selectedTabIndex: 0,
    selectedTab: {},
    tabContents: [],
    changeViewsTab: function (v) {
        var has = false;
        var currIndex = 0;

        var vtm = vmView.viewtabs.$model;
        if (vtm.length === 0) {
            has = false;
        }
        else {
            for (var i = 0, len = vtm.length; i < len; i++) {
                var vt = vtm[i];
                if (vt.sid == v.sid) {
                    currIndex = i;
                    has = true;
                    break;
                }
            }
        }

        if (!has) {//如果还没打开，则打开
            var htmlurl = '/views/' + v.view;
            $.get(htmlurl, function (data) {
                if (vmView.viewtabs.length > 0)
                    vmView.viewtabs[vmView.selectedTabIndex].active = false;

                var currIndex = vmView.viewtabs.length,
                    preIndex = vmView.selectedTabIndex;
                vmView.selectedTabIndex = currIndex;

                data = data.replace('#vmodel#', v.vm);
                var tab = { sid: v.sid, href: v.href, title: v.title, view: data, vm: v.vm, active: true };
                vmView.selectedTab = tab;
                vmView.viewtabs.ensure(tab);
                vmView.tabContents.push(data);
                
            });
        }
        else {
            var preIndex = vmView.selectedTabIndex
            vmView.viewtabs[vmView.selectedTabIndex].active = false;
            vmView.viewtabs[currIndex].active = true;
            vmView.selectedTabIndex = currIndex;
            vmView.selectedTab = vmView.viewtabs.$model[currIndex];//如果已打开，则根据索引号设置选择
            
        }
    },
    onMouseOver: function (e) {
        $(e.target).children('.iconfont').addClass('over');
    },
    onMouseOut: function (e) {
        $(e.target).children('.iconfont').removeClass('over');
    },
    remove: function (i, vt) {
        var active = vt.active;
        vmView.viewtabs.removeAt(i);
        delete avalon.vmodels[vt.vm];
        vmView.tabContents.removeAt(i);

        if (vmView.viewtabs.$model.length === 0) {
            vmView.viewtabs = [];
            vmView.tabContents = [];
        }

        if (vmView.viewtabs.length > 0) {
            var currIndex = 0;
            if (active) {
                //如果关闭的tab是当前选中的，则选中项移到第一个tab
                currIndex = 0;
            }
            else if (i < vmView.selectedTabIndex) {
                //如果移除的tab索引少于当前索引,则当前索引应当-1
                var currIndex = vmView.selectedTabIndex - 1;
            }
            vmView.viewtabs[currIndex].active = true;
            vmView.selectedTab = vmView.viewtabs.$model[currIndex];
            vmView.selectedTabIndex = currIndex;
        }
        else {
            vmView.selectedTab = {};
            vmView.selectedTabIndex = -1;
        }
    },
    toggle: false,
    toggleClass: function () {
        vmView.toggle = !vmView.toggle;
    }
});
