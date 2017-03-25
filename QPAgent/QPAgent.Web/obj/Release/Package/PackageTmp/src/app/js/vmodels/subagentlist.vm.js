var vmsubagentlist = avalon.define({
    $id: 'vmsubagentlist',
    moduleType: 2,
    condition: { keyword: '', status: -1 },
    datasource: [],
    columns: [],
    selectedRowIndex: -1,
    selectedRow: {},
    model: { UserID: -1, UserName: '', oriPassword: '', Password: '', cfPassword: '', IsBand: false, BandIP: '0.0.0.0', RoleID: -1, Nullity: -1 },
    roles: [],
    grades: [],
    IsFind: 0,
    changeStatus: function (e) {
        vmsubagentlist.condition.status = e.target.value;
    },
    /***********注入grid的方法**************/
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&keyword=' + vmsubagentlist.condition.keyword + '&status=' + vmsubagentlist.condition.status + '&IsAgent=' + app.LoginUser.IsAgent;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;
        Du.Get('SubAgents', 'Index', querystring, function (data) {
            vmsubagentlist.datasource = data.result.data;
            vmsubagentlist.config.totalPage = data.result.totalPage;
            vmsubagentlist.config.totalCount = data.result.totalCount;
        });
    },
    findNew: function () {
        if (vmsubagentlist.IsFind == 0) {
            vmsubagentlist.IsFind = 1;
            vmsubagentlist.config.pageIndex = 1;
            vmsubagentlist.fillGrid({ pageIndex: 1, pageSize: vmsubagentlist.config.pageSize });
        }
    },
    find: function () {
        vmsubagentlist.config.pageIndex = 1;
        vmsubagentlist.fillGrid({ pageIndex: 1, pageSize: vmsubagentlist.config.pageSize });
    },
    /****************注入grid方法******************/
    onGridSelectedRowChanged: function (i, r) {
        if (i === vmsubagentlist.selectedRowIndex) return;

        if (vmsubagentlist.selectedRowIndex !== -1) {
            vmsubagentlist.datasource[vmsubagentlist.selectedRowIndex].selected = false;
        }
        vmsubagentlist.datasource[i].selected = true;

        vmsubagentlist.model.UserID = r.UserID;
        vmsubagentlist.model.UserName = r.UserName;
        vmsubagentlist.model.Password = '';
        vmsubagentlist.model.cfPassword = '';
        vmsubagentlist.model.IsBand = r.IsBand;
        vmsubagentlist.model.BandIP = r.BandIP;
        vmsubagentlist.model.RoleID = r.RoleID;
        vmsubagentlist.model.Nullity = r.Nullity;

        vmsubagentlist.selectedRowIndex = i;
        vmsubagentlist.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    reset: function () {
        vmsubagentlist.condition = { keyword: '', status: -1 };
    },
    /*************************************/
    closePwdDialog: function () {
        vmsubagentlist.pwdAnimation = 'enter';
        return false;
    },
    pwdAnimation: 'enter',
    openPwdDialog: function () {
        if (vmsubagentlist.selectedRowIndex == -1) {
            alert('没有选中行！');
            return false;
        }
        vmsubagentlist.pwdAnimation = 'leave';
        return false;
    },
    changePwd: function () {
        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=ch_pwd';
        querystring += '&UserID=' + vmsubagentlist.model.UserID + '&UserName=' + vmsubagentlist.model.UserName;
        Du.Post('SubAgents', 'Edit', querystring, function (data) {
            if (data.status == 'success') {
                vmsubagentlist.closePwdDialog();
            }
            MessageBox.show(data);
        });

        return false;
    },
    submit: function (formid) {
        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=' + vmsubagentlist.vmState;
        Du.PostFormData('SubAgents', 'Edit', querystring, $(e.target).serialize(), function (data) {
            if (data.status == 'success') {
                vmsubagentlist.closePwdDialog();
            }
            MessageBox.show(data);
        });
    },
    getIds: function () {
        var ids = '';
        var dm = vmsubagentlist.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i].UserID;
            }
        }

        return ids.substring(1, ids.length);;
    },
    dj: function (e) {
        ids = vmsubagentlist.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=dj&ids=' + ids;
        Du.Post('SubAgents', 'Edit', querystring, function (data) {
            MessageBox.show(data);
            vmsubagentlist.find();
        });
    },
    jd: function (e) {
        ids = vmsubagentlist.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=jd&ids=' + ids;
        Du.Post('SubAgents', 'Edit', querystring, function (data) {
            MessageBox.show(data);
            vmsubagentlist.find();
        });

        return false;
    },
    getBindData: function () {
        var querystring = '&moduleType=' + vmsubagentlist.moduleType;
        querystring += '&subType=binddata';
        Du.Post('SubAgents', 'Index', querystring, function (data) {
            MessageBox.success(data);
            var roles = data.result.AgentRoles;
            vmsubagentlist.roles = data.result.AgentRoles;
            vmsubagentlist.grades = data.result.AgentGrades;
        });
    },
    getAgentGrades: function () {

    },
    init: function () {
        //vmInfo.getBindData();
        vmsubagentlist.find();
    },
    sort: function (col) {
        vmsubagentlist.datasource.sort(function (a, b) {
            return a[col] > b[col];
        });
    },
    gridsorticon: false,
    toggleGridSortBtn: function () {
        vmsubagentlist.gridsorticon = !vmsubagentlist.gridsorticon;
        vmsubagentlist.ToBig;
    },
    sortDesc: function (col) {
        if (vmsubagentlist.selectedRowIndex !== -1) {
            vmsubagentlist.datasource[vmsubagentlist.selectedRowIndex].selected = false;
        }
        vmsubagentlist.datasource.sort(function (a, b) {
            if (col == 'LastLogintime') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmsubagentlist.selectedRowIndex !== -1) {
            vmsubagentlist.datasource[vmsubagentlist.selectedRowIndex].selected = false;
        }
        vmsubagentlist.datasource.sort(function (a, b) {
            if (col == 'LastLogintime') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmsubagentlist.datasource.forEach(function (el) {
            el.checked = checked
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmsubagentlist.allchecked = false
        } else {
            vmsubagentlist.allchecked = vmsubagentlist.datasource.every(function (el) {
                return el.checked
            })
        }
    },
    GetColor: function (des) {
        var color;
        switch (des) {
            case '金牌1':
                color = '#886600';
                break;
            case '金牌2':
                color = '#AA7700';
                break;
            case '金牌3':
                color = '#DDAA00';
                break;
            case '金牌4':
                color = '#FFBB00';
                break;
            case '金牌5':
                color = '#FFCC22';
                break;
            case '银牌1':
                color = '#0088A8';
                break;
            case '银牌2':
                color = '#009FCC'
                break;
            case '银牌3':
                color = '#00BBFF';
                break;
            case '银牌4':
                color = '#33CCFF';
                break;
            case '银牌5':
                color = '#77DDFF';
                break;
        }
        return color;
    }

});
