var vmGamerlistInfo = avalon.define({
    $id: 'vmGamerlistInfo',
    condition: { GameID: '', Accounts: '', Range: 0, startDate: '', endDate: '', userType: 'admin', byUserID: -1 },
    datasource: [],
    selectedRow: {},
    selectedRowIndex: -1,
    IsFind: 0,
    onRowChanged: function (i, r) {
        if (i === vmGamerlistInfo.selectedRowIndex) return;

        if (vmGamerlistInfo.selectedRowIndex !== -1) {
            vmGamerlistInfo.datasource[vmGamerlistInfo.selectedRowIndex].selected = false;
        }
        vmGamerlistInfo.datasource[i].selected = true;

        vmGamerlistInfo.selectedRowIndex = i;
        vmGamerlistInfo.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    fillGrid: function (e) {
        if (vmInfo.selectedTreeNode.IsAgent) {
            vmGamerlistInfo.condition.userType = 'agent';
        }
        else {
            vmGamerlistInfo.condition.userType = 'admin';
        }
        if (vmGamerlistInfo.condition.GameID && !/^\s*\d*\s*$/.test(vmGamerlistInfo.condition.GameID)) {
            alert("玩家ID只能输入数字！");
            return false;
        }
        var loading = $.loading('正在加载数据，请稍后...', '.viewpage');
        var url = '/ajaxControllers.ashx?controller=MyInfo&type=Index&subType=gamerlist';
        url += '&GameID=' + (vmGamerlistInfo.condition.GameID || '-1');
        url += '&Accounts=' + vmGamerlistInfo.condition.Accounts;
        url += '&Range=' + vmGamerlistInfo.condition.Range;
        url += '&startDate=' + vmGamerlistInfo.condition.startDate;
        url += '&endDate=' + vmGamerlistInfo.condition.endDate;
        url += '&userType=' + vmGamerlistInfo.condition.userType;
        url += '&byUserID=' + vmGamerlistInfo.condition.byUserID;
        if (e.pageIndex)
            url += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            url += '&pageSize=' + e.pageSize;
        $.ajax({
            url: url,
            method: 'GET',
            success: function (data) {
                loading.close();
                MessageBox.success(data);
                vmGamerlistInfo.datasource.clear();
                vmGamerlistInfo.datasource = data.result.data;
                vmGamerlistInfo.config.totalPage = data.result.totalPage;
                vmGamerlistInfo.config.totalCount = data.result.totalCount;
            },
            error: function (err) {
                loading.close();
                MessageBox.error(err.responseText);
            }
        });
        return false;
    },
    findNew: function () {
        if (vmGamerlistInfo.IsFind == 0) {
            vmGamerlistInfo.IsFind = 1;
            vmGamerlistInfo.config.pageIndex = 1;
            vmGamerlistInfo.fillGrid({ pageIndex: 1, pageSize: vmGamerlistInfo.config.pageSize });
        }
    },
    find: function () {
        vmGamerlistInfo.config.pageIndex = 1;
        vmGamerlistInfo.fillGrid({ pageIndex: 1, pageSize: vmGamerlistInfo.config.pageSize });
    },
    clearDatasource: function () {
        vmGamerlistInfo.datasource.clear();
        vmGamerlistInfo.config.totalPage = 0;
        vmGamerlistInfo.config.totalCount = 0;
    },
    clearCondition: function () {
        vmGamerlistInfo.condition.GameID = '';
        vmGamerlistInfo.condition.Accounts = '';
        vmGamerlistInfo.condition.Range = 0;
        vmGamerlistInfo.condition.startDate = '';
        vmGamerlistInfo.condition.endDate = '';
    },
    noSelfCheck: function (UserID) {
        if (UserID === vmInfo.selectedTreeNode.id && app.LoginUser.IsAgent)
            return true;
        return false;
    },
    noCheckSelf: function () {
        if (app.LoginUser.IsAgent) {
            var selfIndex = -1;
            var dm = vmGamerlistInfo.datasource;
            dm.forEach(function (el, i) {
                if (el.UserID === vmInfo.selectedTreeNode.id) {
                    selfIndex = i;
                }
            });
            if (selfIndex !== -1) {
                vmGamerlistInfo.datasource[selfIndex].checked = false;
            }
        }
    },
    getIds: function (idname) {
        var ids = '';
        var dm = vmGamerlistInfo.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i][idname];
            }
        }
        return ids.substring(1, ids.length);;
    },
    checkIds: function () {
        var ids = vmGamerlistInfo.getIds('UserID');
        return ids;
    },
    sortDesc: function (col) {
        if (vmGamerlistInfo.selectedRowIndex !== -1) {
            vmGamerlistInfo.datasource[vmGamerlistInfo.selectedRowIndex].selected = false;
        }
        vmGamerlistInfo.datasource.sort(function (a, b) {
            if (col == 'SpreaderDate') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmGamerlistInfo.selectedRowIndex !== -1) {
            vmGamerlistInfo.datasource[vmGamerlistInfo.selectedRowIndex].selected = false;
        }
        vmGamerlistInfo.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'SpreaderDate') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    maxCellWidth: 20,
    ColumnWidthObj: { checked: 2, GameID: 7, Accounts: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7, AllWaste: 7 },
    getFitCellWidth: function (col, minWidth, content) {
        vmGamerlistInfo.ColumnWidthObj[col] = minWidth;
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmGamerlistInfo.datasource.forEach(function (el) {
            if (!app.LoginUser.IsAgent) {
                el.checked = checked;
            }
            else if (el.UserID != app.LoginUser.AgentID) {
                el.checked = checked;
            }
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmGamerlistInfo.allchecked = false
        } else {
            vmGamerlistInfo.allchecked = vmGamerlistInfo.datasource.every(function (el) {
                return el.checked
            })
        }
    }
})