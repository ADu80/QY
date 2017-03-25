var vmlog = avalon.define({
    $id: 'vmlog',
    moduleType: 6,
    datasource: [],
    columns: [],
    condition: { startDate: '', endDate: '', OperationID: -1, Accounts: '' },
    operations: [],
    selectedRowIndex: 0,
    selectedRow: {},
    IsFind: 0,
    /***********注入grid的方法**************/
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmlog.moduleType;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;
        querystring += '&startDate=' + vmlog.condition.startDate + '&endDate=' + vmlog.condition.endDate;
        querystring += '&OperationID=' + vmlog.condition.OperationID;
        querystring += '&userType=' + (app.LoginUser.IsAgent ? 'agent' : 'admin');
        querystring += '&byAdminID=' + app.LoginUser.UserID;

        Du.Loading('Log', 'Index', querystring, function (data) {
            vmlog.datasource = data.result.data;
            vmlog.config.totalPage = data.result.totalPage;
            vmlog.config.totalCount = data.result.totalCount;
        });
    },
    find: function () {
        vmlog.config.pageIndex = 1;
        vmlog.fillGrid({ pageIndex: 1, pageSize: vmlog.config.pageSize });
    },
    findNew: function () {
        if (vmlog.IsFind == 0) {
            vmlog.IsFind = 1;
            vmlog.config.pageIndex = 1;
            vmlog.fillGrid({ pageIndex: 1, pageSize: vmlog.config.pageSize });
        }
    },
    reset: function () {
        vmlog.condition = { startDate: '', endDate: '', OperationID: -1, Accounts: '' };
    },
    onGridSelectedRowChanged: function (i, r) {
        if (i === vmlog.selectedRowIndex) return;

        if (vmlog.selectedRowIndex !== -1) {
            vmlog.datasource[vmlog.selectedRowIndex].selected = false;
        }
        vmlog.datasource[i].selected = true;
        vmlog.selectedRowIndex = i;
        vmlog.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    /*************************************/
    getOperations: function () {
        var querystring = '&moduleType=' + vmlog.moduleType + '&dataType=operations';
        Du.Get('Log', 'Index', querystring, function (data) {
            vmlog.operations = data.result;
        });
    },
    init: function () {
        vmlog.getOperations();
        vmlog.find();
    },
    sortDesc: function (col) {
        if (vmlog.selectedRowIndex !== -1) {
            vmlog.datasource[vmlog.selectedRowIndex].selected = false;
        }
        vmlog.datasource.sort(function (a, b) {
            if (col == 'PreLogintime' || col == 'LastLogintime') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });
    },
    sortAsc: function (col) {
        if (vmlog.selectedRowIndex !== -1) {
            vmlog.datasource[vmlog.selectedRowIndex].selected = false;
        }
        vmlog.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'LastLogintime' || col == 'PreLogintime') {
                return new Date(a[col]) > new Date(b[col]);
            }

            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmlog.datasource.forEach(function (el) {
            el.checked = checked
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmlog.allchecked = false
        } else {
            vmlog.allchecked = vmlog.datasource.every(function (el) {
                return el.checked
            })
        }
    }
});
vmlog.$watch('onReady', function () {
    setTimeout(function () {
        $('input[data-date="datepicker"]').datepicker({
            format: 'yyyy-mm-dd'
        });
    });
});