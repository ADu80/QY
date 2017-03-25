var vmadmin = avalon.define({
    $id: 'vmadmin',
    moduleType: 3,
    condition: { keyword: '', status: -1 },
    datasource: [],
    columns: [],
    selectedRowIndex: -1,
    selectedRow: {},
    IsFind: 0,
    newModel: { UserID: -1, UserName: '', oriPassword: '', Password: '', cfPassword: '', IsBand: false, BandIP: '0.0.0.0', RoleID: -1, Nullity: 0 },
    editModel: { UserID: -1, UserName: '', oriPassword: '', Password: '', cfPassword: '', IsBand: false, BandIP: '0.0.0.0', RoleID: -1, Nullity: 0 },
    roles: [],
    changeStatus: function (e) {
        vmadmin.condition.status = e.target.value;
    },
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&keyword=' + vmadmin.condition.keyword + '&status=' + vmadmin.condition.status;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;
        Du.Loading('Admin', 'Index', querystring, function (data) {
            vmadmin.datasource = data.result.data;
            vmadmin.config.totalPage = data.result.totalPage;
            vmadmin.config.totalCount = data.result.totalCount;
            if (vmadmin.selectedRowIndex != -1) {
                vmadmin.datasource[vmadmin.selectedRowIndex].selected = true;
            }
        });
    },
    findNew: function () {
        if (vmadmin.IsFind == 0) {
            vmadmin.IsFind = 1;
            vmadmin.config.pageIndex = 1;
            vmadmin.fillGrid({ pageIndex: 1, pageSize: vmadmin.config.pageSize });
        }
    },
    find: function () {
        vmadmin.config.pageIndex = 1;
        vmadmin.fillGrid({ pageIndex: 1, pageSize: vmadmin.config.pageSize });
    },
    reset: function () {
        vmadmin.condition = { keyword: '', status: -1 };
    },
    /***********注入grid的方法**************/
    onGridSelectedRowChanged: function (i, r) {
        if (i === vmadmin.selectedRowIndex) return;

        if (vmadmin.selectedRowIndex !== -1) {
            vmadmin.datasource[vmadmin.selectedRowIndex].selected = false;
        }
        vmadmin.datasource[i].selected = true;

        vmadmin.editModel.UserID = r.UserID;
        vmadmin.editModel.UserName = r.UserName;
        vmadmin.editModel.Password = '';
        vmadmin.editModel.cfPassword = '';
        vmadmin.editModel.IsBand = r.IsBand;
        vmadmin.editModel.BandIP = r.BandIP;
        vmadmin.editModel.RoleID = r.RoleID;
        vmadmin.editModel.Nullity = r.Nullity;

        vmadmin.selectedRowIndex = i;
        vmadmin.selectedRow = r;
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    clearModel: function () {
        vmadmin.newModel.UserID = -1;
        vmadmin.newModel.UserName = '';
        vmadmin.newModel.Password = '';
        vmadmin.newModel.cfPassword = '';
        vmadmin.newModel.BandIP = '0.0.0.0';
        vmadmin.newModel.IsBand = false;
        vmadmin.newModel.RoleID = -1;
        vmadmin.newModel.Nullity = 0;
    },
    /*************************************/
    closeAddDialog: function () {
        vmadmin.addAnimation = 'enter';
        vmadmin.clearModel();
        vmadmin.vmState = 'none';
    },
    closeEditDialog: function () {
        vmadmin.editAnimation = 'enter';
        vmadmin.clearModel();
        vmadmin.vmState = 'none';
    },
    closeRoleDialog: function () {
        vmadmin.roleAnimation = 'enter';
        vmadmin.clearModel();
        vmadmin.vmState = 'none';
    },
    closePwdDialog: function () {
        vmadmin.pwdAnimation = 'enter';
        vmadmin.clearModel();
        vmadmin.vmState = 'none';
    },
    vmState: 'none',
    addAnimation: 'enter',
    editAnimation: 'enter',
    roleAnimation: 'enter',
    pwdAnimation: 'enter',
    vpageChange: function (page) {
        if (page === 'add') {
            vmadmin.vmState = 'add';
            vmadmin.addAnimation = 'leave';
        }
        else if (page === 'edit') {
            if (vmadmin.selectedRowIndex == -1) {
                alert('没有选中行！');
                return false;
            }
            var sr = vmadmin.datasource.$model[vmadmin.selectedRowIndex];
            vmadmin.editModel.UserID = sr.UserID;
            vmadmin.editModel.UserName = sr.UserName;
            vmadmin.editModel.IsBand = sr.IsBand;
            vmadmin.editModel.BandIP = sr.BandIP;
            vmadmin.editModel.RoleID = sr.RoleID;
            vmadmin.vmState = 'edit';
            vmadmin.editAnimation = 'leave';
        }
        else if (page === 'ch_role') {
            if (vmadmin.selectedRowIndex == -1) {
                alert('没有选中行！');
                return false;
            }
            var sr = vmadmin.datasource.$model[vmadmin.selectedRowIndex];
            vmadmin.editModel.UserID = sr.UserID;
            vmadmin.editModel.UserName = sr.UserName;
            vmadmin.editModel.RoleID = sr.RoleID;
            vmadmin.vmState = 'ch_role';
            vmadmin.roleAnimation = 'leave';
        }
        else if (page === 'ch_pwd') {
            if (vmadmin.selectedRowIndex == -1) {
                alert('没有选中行！');
                return false;
            }
            vmadmin.vmState = 'ch_pwd';
            vmadmin.pwdAnimation = 'leave';
        }
        //vmadmin.editpage = page;
        return false;
    },
    changePwd: function () {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&subType=ch_pwd';
        querystring += '&UserID=' + vmadmin.editModel.UserID + '&UserName=' + vmadmin.editModel.UserName;

        Du.Post('Admin', 'Edit', querystring, function (data) {
            if (data.status == 'success') {
                //vmadmin.vpageBack();
                vmadmin.closePwdDialog();
            }
            MessageBox.show(data);
        });
    },
    submit: function (e) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        var type = '';
        if (vmadmin.vmState == 'add')
            type = 'New';
        else if (vmadmin.vmState == 'edit')
            type = 'Edit';
        else if (vmadmin.vmState == 'ch_role') {
            type = 'Edit';
            querystring += '&subType=' + vmadmin.vmState;
        }
        else if (vmadmin.vmState == 'ch_pwd') {
            type = 'Edit';
            querystring += '&subType=' + vmadmin.vmState;
        }
        var data = $(e.target).serialize();
        if (type == 'New') {
            var g_UserName = e.target.UserName.value;
            var g_Password = e.target.Password.value;
            var g_cfPassword = e.target.cfPassword.value;
            if (g_UserName == '') {
                alert('用户名不能为空!'); return;
            }
            if (g_Password == '') {
                alert('密码不能为空!'); return;
            }
            if (g_cfPassword != g_Password) {
                alert('确认密码不一致!'); return;
            }
        }
        if (type == 'Edit') {
            var g_UserName = e.target.UserName.value;
            if (g_UserName == '') {
                alert('用户名不能为空!'); return;
            }

        }
        Du.PostFormData('Admin', type, querystring, data, function (data) {
            if (data.status == 'success') {
                //vmadmin.vpageBack();
                switch (vmadmin.vmState) {
                    case 'add':
                        if (data.message != "用户名已经存在！") {
                            vmadmin.closeAddDialog();
                            vmadmin.find();
                        }
                        break;
                    case 'edit':
                        if (data.message != "用户名已经存在！") {
                            vmadmin.closeEditDialog();
                            vmadmin.find();
                        }
                        break;
                    case 'ch_role':
                        vmadmin.closeRoleDialog();
                        break;
                    case 'ch_pwd':
                        vmadmin.closePwdDialog();
                        break;
                }
            }
            MessageBox.show(data);
        });
    },
    getIds: function () {
        var ids = '';
        var dm = vmadmin.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i].UserID;
            }
        }
        return ids.substring(1, ids.length);;
    },
    del: function () {
        ids = vmadmin.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&ids=' + ids;
        Du.Post('Admin', 'Delete', querystring, function (data) {
            MessageBox.show(data);
            vmadmin.find();
        });
    },
    dj: function () {
        ids = vmadmin.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&subType=dj&ids=' + ids;
        Du.Post('Admin', 'Edit', querystring, function (data) {
            MessageBox.show(data);
            vmadmin.find();
        });
    },
    jd: function () {
        ids = vmadmin.getIds();
        if (ids.length == 0) {
            MessageBox.error('请先勾选行！');
            return false;
        }

        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&subType=jd&ids=' + ids;
        Du.Post('Admin', 'Edit', querystring, function (data) {
            MessageBox.show(data);
            vmadmin.find();
        });

        return false;
    },
    init: function () {
        vmadmin.find();
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;

        Du.Get('Roles', 'Index', querystring, function (data) {
            MessageBox.success(data);
            var roles = data.result.data;

            for (var i in roles) {
                if (roles[i].AgentLevel == 0) {
                    vmadmin.roles.push(roles[i]);
                }
            }
        });
    },
    sortDesc: function (col) {
        if (vmadmin.selectedRowIndex !== -1) {
            vmadmin.datasource[vmadmin.selectedRowIndex].selected = false;
        }
        vmadmin.datasource.sort(function (a, b) {
            if (col == 'PreLogintime' || col == 'LastLogintime') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });
    },
    sortAsc: function (col) {
        if (vmadmin.selectedRowIndex !== -1) {
            vmadmin.datasource[vmadmin.selectedRowIndex].selected = false;
        }
        vmadmin.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'PreLogintime' || col == 'LastLogintime') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmadmin.datasource.forEach(function (el) {
            if (el.UserName !== 'admin') {
                el.checked = checked
            }
        });
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            vmadmin.allchecked = false
        } else {
            vmadmin.allchecked = vmadmin.datasource.every(function (el) {
                return el.checked
            })
        }
    }

});
