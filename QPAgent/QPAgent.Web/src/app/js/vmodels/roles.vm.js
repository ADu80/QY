var vmroles = avalon.define({
    $id: 'vmroles',
    moduleType: 4,
    table: '',
    vmState: 'none',
    editBoxTitle: '新增角色',
    dialogAddAnimation: 'enter',
    dialogEditAnimation: 'enter',
    IsFind: 0,
    closeAddDialog: function (e) {
        vmroles.dialogAddAnimation = 'enter';
    },
    closeEditDialog: function (e) {
        vmroles.dialogEditAnimation = 'enter';
    },
    openAddDialog: function (e) {
        var now = new Date().Format('yyyy-MM-dd');

        var newrole = { RoleID: 0, RoleName: '', Description: '', Operator: app.LoginUser.UserName, Created: now, Modified: now };
        vmroles.newRole = newrole;
        vmroles.editBoxTitle = '新增角色';
        vmroles.dialogAddAnimation = 'leave';
        vmroles.vmState = 'add';
    },
    openEditDialog: function (e) {
        if (vmroles.selectedRowIndex == -1) {
            MessageBox.error('没有选中行！');
            return false;
        }
        vmroles.editBoxTitle = '新增角色';
        vmroles.selectedRole.Operator = app.LoginUser.UserName;
        vmroles.selectedRole.Modified = new Date().Format('yyyy-MM-dd');
        vmroles.dialogEditAnimation = 'leave';
        vmroles.vmState = 'edit';
    },
    datasource: [],
    datasource2: [],
    columns: [],
    newRole: { RoleID: '', RoleName: '', Description: '', AgentLevel: 1, Operator: '', Created: '', Modified: '' },
    selectedRole: { RoleID: '', Operator: '', RoleName: '', Description: '', Created: new Date().Format('yyyy-MM-dd'), Modified: new Date().Format('yyyy-MM-dd') },
    //selectedRole: { checked: false, selected: false, RoleID: '', RoleName: '', Description: '', AgentLevel: 1, Operator: '', Created: new Date().Format('yyyy-MM-dd'), Modified: new Date().Format('yyyy-MM-dd') },
    selectedRowIndex: -1,
    onNewRoleChanged: function (i, r) {
        if (i === vmroles.selectedRowIndex) return;

        if (vmroles.selectedRowIndex !== -1) {
            vmroles.datasource[vmroles.selectedRowIndex].selected = false;
        }
        vmroles.datasource[i].selected = true;

        vmroles.selectedRowIndex = i;
        vmroles.selectedRole.RoleID = r.RoleID;
        vmroles.selectedRole.RoleName = r.RoleName;
        vmroles.selectedRole.Description = r.Description;
        vmroles.selectedRole.Created = new Date(r.Created).Format('yyyy-MM-dd');
    },
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmroles.moduleType;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;

        Du.Loading('Roles', 'Index', querystring, function (data) {
            vmroles.datasource = data.result.data;
            vmroles.datasource2 = data.result.data;
            vmroles.config.totalPage = data.result.totalPage;
            vmroles.config.totalCount = data.result.totalCount;
        });
    },
    findNew: function () {
        if (vmroles.IsFind == 0) {
            vmroles.IsFind = 1;
            vmroles.config.pageIndex = 1;
            vmroles.fillGrid({ pageIndex: 1, pageSize: vmroles.config.pageSize });
        }
    },
    find: function () {
        vmroles.config.pageIndex = 1;
        vmroles.fillGrid({ pageIndex: 1, pageSize: vmroles.config.pageSize });
    },
    submit: function (e) {
        var querystring = '&moduleType=' + vmroles.moduleType;
        var data = $(e.target).serialize();
        var type = '';
        if (vmroles.vmState == 'add') {
            type = 'New';
        }
        else if (vmroles.vmState == 'edit') {
            type = 'Edit';
        }

        Du.PostFormData('Roles', type, querystring, data, function (data) {
            vmroles.closeAddDialog();
            vmroles.closeEditDialog();
            vmroles.refresh();
            MessageBox.show(data);
        });
    },
    getIds: function () {
        var ids = '';
        var dm = vmroles.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i].RoleID;
            }
        }
        return ids.substring(1, ids.length);;
    },
    del: function () {
        var ids = vmroles.getIds();
        if (ids === '') {
            MessageBox.error("请先勾选行！");
            return false;
        }
        var querystring = '&moduleType=' + vmroles.moduleType;
        querystring += '&ids=' + ids;
        Du.Post('Roles', 'Delete', querystring, function (data) {
            vmroles.refresh();
            MessageBox.show(data);
        });
    },
    refresh: function () {
        vmroles.config.pageIndex = 1;
        vmroles.fillGrid({ pageIndex: 1, pageSize: vmroles.config.pageSize });
    },
    init: function () {
        vmroles.refresh();
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    sortDesc: function (col) {
        if (vmroles.selectedRowIndex !== -1) {
            vmroles.datasource[vmroles.selectedRowIndex].selected = false;
        }
        vmroles.datasource.sort(function (a, b) {
            if (col == 'Created' || col == 'Modified') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmroles.selectedRowIndex !== -1) {
            vmroles.datasource[vmroles.selectedRowIndex].selected = false;
        }
        vmroles.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'Created' || col == 'Modified') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        vmroles.datasource.forEach(function (el) {
            if (el.RoleID != 1) {
                el.checked = checked;
            }
        });
    },
    checkOne: function (e) {

        var checked = e.target.checked
        if (checked === false) {
            vmroles.allchecked = false
        } else {
            vmroles.allchecked = vmroles.datasource.every(function (el) {
                return el.checked
            })
        }
    }
});
