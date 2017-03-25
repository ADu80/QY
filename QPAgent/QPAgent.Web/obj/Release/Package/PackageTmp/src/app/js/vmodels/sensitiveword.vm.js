var vmsensitiveword = avalon.define({
    $id: 'vmsensitiveword',
    moduleType: 7,
    vmState: 'none',
    condition: { keyword: '' },
    selectedRow: {},
    selectedRowIndex: -1,
    datasource: [],
    IsFind: 0,
    onGridSelectedRowChanged: function (i, r) {
        if (i === vmsensitiveword.selectedRowIndex) return;

        if (vmsensitiveword.selectedRowIndex !== -1) {
            vmsensitiveword.datasource[vmsensitiveword.selectedRowIndex].selected = false;
        }
        vmsensitiveword.datasource[i].selected = true;

        vmsensitiveword.selectedRowIndex = i;
        vmsensitiveword.selectedRow = r;
        //vmsensitiveword.selectedRow.LastTime = new Date(r.LastTime).Format('yyyy-MM-dd HH:mm:ss');
    },
    /***********注入grid的方法**************/
    fillGrid: function (e) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&keyword=' + vmsensitiveword.condition.keyword;
        if (e.pageIndex)
            querystring += '&pageIndex=' + e.pageIndex;
        if (e.pageSize)
            querystring += '&pageSize=' + e.pageSize;

        Du.Get('SensitiveWord', 'Index', querystring,
            function (data) {
                vmsensitiveword.datasource = data.result.data;
                vmsensitiveword.config.totalPage = data.result.totalPage;
                vmsensitiveword.config.totalCount = data.result.totalCount;
                if (vmsensitiveword.selectedRowIndex != -1) {
                    vmsensitiveword.datasource[vmsensitiveword.selectedRowIndex].selected = true;
                }
            });
    },
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    findNew: function () {
        if (vmsensitiveword.IsFind == 0) {
            vmsensitiveword.IsFind = 1;
            vmsensitiveword.config.pageIndex = 1;
            vmsensitiveword.fillGrid({ pageIndex: 1, pageSize: vmsensitiveword.config.pageSize });
        }
    },
    find: function () {
        vmsensitiveword.config.pageIndex = 1;
        vmsensitiveword.fillGrid({ pageIndex: 1, pageSize: vmsensitiveword.config.pageSize });
    },
    refresh: function () {
        vmsensitiveword.fillGrid({ pageIndex: vmsensitiveword.config.pageIndex, pageSize: vmsensitiveword.config.pageSize });
    },
    reset: function () {
        vmsensitiveword.condition = { keyword: '', status: -1 };
    },
    editpage: 'none',
    addAnimation: 'enter',
    editAnimation: 'enter',
    showAddDialog: function (e) {
        vmsensitiveword.addAnimation = 'leave';
        vmsensitiveword.newModel = { SensitiveWord: '', LastTime: new Date().Format('yyyy-MM-dd HH:mm:ss') };

    },
    showEditDialog: function (r) {
        vmsensitiveword.editAnimation = 'leave';
        vmsensitiveword.editModel.ID = r.ID;
        vmsensitiveword.editModel.SensitiveWord = r.SensitiveWord;
        vmsensitiveword.editModel.LastTime = new Date().Format('yyyy-MM-dd HH:mm:ss');
    },
    closeAddDialog: function (e) {
        vmsensitiveword.addAnimation = 'enter';
    },
    closeEditDialog: function (e) {
        vmsensitiveword.editAnimation = 'enter';
    },
    newModel: { SensitiveWord: '', LastTime: '' },
    editModel: { ID: -1, SensitiveWord: '', OldSensitiveWord: '', LastTime: '' },
    addSubmit: function (e) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&' + $(e.target).serialize();
        console.log(querystring);
        Du.Post('SensitiveWord', 'New', querystring,
            function (data) {
                if (data.status == 'success') {
                    vmsensitiveword.closeAddDialog();
                }
                MessageBox.show(data);
                vmsensitiveword.refresh();
            });
    },
    editSubmit: function (e) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&' + $(e.target).serialize() + '&OldSensitiveWord' + vmsensitiveword.editModel.OldSensitiveWord;
        Du.Post('SensitiveWord', 'Edit', querystring,
            function (data) {
                if (data.status == 'success') {
                    vmsensitiveword.closeEditDialog();
                }
                MessageBox.show(data);
                vmsensitiveword.refresh();
            });
    },
    del: function (id) {
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&ids=' + id;
        Du.Post('SensitiveWord', 'Delete', querystring,
            function (data) {
                MessageBox.show(data);
                vmsensitiveword.selectedRowIndex = -1;
                vmsensitiveword.refresh();
            });
    },
    delS: function () {
        var ids = vmsensitiveword.checkIds();
        if (!ids) {
            MessageBox.error("请先勾选行");
            return;
        }
        var querystring = '&moduleType=' + vmsensitiveword.moduleType;
        querystring += '&ids=' + ids;
        Du.Post('SensitiveWord', 'Delete', querystring,
            function (data) {
                MessageBox.show(data);
                vmsensitiveword.selectedRowIndex = -1;
                vmsensitiveword.refresh();
            });
    },
    getIds: function (idname) {
        var ids = '';
        var dm = vmsensitiveword.datasource.$model;
        for (var i in dm) {
            if (dm[i].checked) {
                ids += ',' + dm[i][idname];
            }
        }
        return ids.substring(1, ids.length);;
    },
    checkIds: function () {
        var ids = vmsensitiveword.getIds('ID');
        return ids;
    },
    allchecked: false,
    checkAll: function (e) {
        var checked = e.target.checked
        this.datasource.forEach(function (el) {
            el.checked = checked
        });
        this.setSkipChecked();
    },
    checkOne: function (e) {
        var checked = e.target.checked
        if (checked === false) {
            this.allchecked = false
        } else {
            this.allchecked = this.datasource.every(function (el) {
                return el.checked
            })
        }
    },
    init: function () {
        vmsensitiveword.find();
    }
});