var vmSubAgentlistInfo = avalon.define({
    $id: 'vmSubAgentlistInfo',
    moduleType: 1,
    condition: { SpreaderID: '', Accounts: '', Range: 0, startDate: '', endDate: '', userType: 'admin', byUserID: -1 },
    datasource: [],
    selectedRow: {},
    selectedRowIndex: -1,
    IsFind: 0,
    onRowChanged: function (i, r) {
        if (i === vmSubAgentlistInfo.selectedRowIndex) return;

        if (vmSubAgentlistInfo.selectedRowIndex !== -1) {
            vmSubAgentlistInfo.datasource[vmSubAgentlistInfo.selectedRowIndex].selected = false;
        }
        vmSubAgentlistInfo.datasource[i].selected = true;

        vmSubAgentlistInfo.selectedRowIndex = i;
        vmSubAgentlistInfo.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    fillGrid: function (e) {
        if (vmInfo.selectedTreeNode.IsAgent) {
            vmSubAgentlistInfo.condition.userType = 'agent';
        }
        else {
            vmSubAgentlistInfo.condition.userType = 'admin';
        }

        var querystring = '&moduleType=' + vmlog.moduleType;
        querystring += '&subType=subagentlist';
        querystring += '&SpreaderID=' + (vmSubAgentlistInfo.condition.SpreaderID || '-1');
        querystring += '&Accounts=' + vmSubAgentlistInfo.condition.Accounts;
        querystring += '&Range=' + vmSubAgentlistInfo.condition.Range;
        querystring += '&startDate=' + vmSubAgentlistInfo.condition.startDate;
        querystring += '&endDate=' + vmSubAgentlistInfo.condition.endDate;
        querystring += '&userType=' + vmSubAgentlistInfo.condition.userType;
        querystring += '&byUserID=' + vmSubAgentlistInfo.condition.byUserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmSubAgentlistInfo.datasource.clear();
            vmSubAgentlistInfo.datasource = data.result.data;
            vmSubAgentlistInfo.config.totalPage = data.result.totalPage;
            vmSubAgentlistInfo.config.totalCount = data.result.totalCount;
        });
    },
    findNew: function () {
        if (vmSubAgentlistInfo.IsFind == 0) {
            vmSubAgentlistInfo.IsFind = 1;
            vmSubAgentlistInfo.config.pageIndex = 1;
            vmSubAgentlistInfo.fillGrid({ pageIndex: 1, pageSize: vmSubAgentlistInfo.config.pageSize });
        }
    },
    find: function () { 
            vmSubAgentlistInfo.config.pageIndex = 1;
            vmSubAgentlistInfo.fillGrid({ pageIndex: 1, pageSize: vmSubAgentlistInfo.config.pageSize });
    },
    clearDatasource: function () {
        vmSubAgentlistInfo.datasource.clear();
        vmSubAgentlistInfo.config.totalPage = 0;
        vmSubAgentlistInfo.config.totalCount = 0;
    },
    clearCondition: function () {
        vmSubAgentlistInfo.condition.SpreaderID = '';
        vmSubAgentlistInfo.condition.Accounts = '';
        vmSubAgentlistInfo.condition.Range = 0;
        vmSubAgentlistInfo.condition.startDate = '';
        vmSubAgentlistInfo.condition.endDate = '';
    },
    getIds: function (idname) {
        var ids = '';
        var dm = vmSubAgentlistInfo.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i][idname];
            }
        }
        return ids.substring(1, ids.length);;
    },
    checkIds: function () {
        var ids = vmSubAgentlistInfo.getIds('UserID');
        return ids;
    },

    sortDesc: function (col) {
        if (vmSubAgentlistInfo.selectedRowIndex !== -1) {
            vmSubAgentlistInfo.datasource[vmSubAgentlistInfo.selectedRowIndex].selected = false;
        }
        vmSubAgentlistInfo.datasource.sort(function (a, b) {
            if (col == 'SpreaderDate') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmSubAgentlistInfo.selectedRowIndex !== -1) {
            vmSubAgentlistInfo.datasource[vmSubAgentlistInfo.selectedRowIndex].selected = false;
        }
        vmSubAgentlistInfo.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'SpreaderDate') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmSubAgentlistInfo.datasource.forEach(function (el) {
            el.checked = checked
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmSubAgentlistInfo.allchecked = false
        } else {
            vmSubAgentlistInfo.allchecked = vmSubAgentlistInfo.datasource.every(function (el) {
                return el.checked
            })
        }
    }
});