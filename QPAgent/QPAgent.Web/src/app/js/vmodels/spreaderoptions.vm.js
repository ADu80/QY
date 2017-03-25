var vmspreaderoptions = avalon.define({
    $id: 'vmspreaderoptions',
    moduleType: 5,
    AgentRoles: [],
    AgentGrades: [],
    ggOption: { RoleID: -1, GradeID: -1, TotalSpreaderRate: '', ASpreaderRate: '', BSpreaderRate: '', CSpreaderRate: '' },
    pgOption: { RoleID: -1, GradeID: -1, TotalSpreaderRate: '', ASpreaderRate: '', BSpreaderRate: '', CSpreaderRate: '' },
    bindData: function () {
        var querystring = '&moduleType=' + vmspreaderoptions.moduleType;
        querystring += '&subType=binddata';
        Du.Get('Spreaderoptions', 'Index', querystring, function (data) {
            MessageBox.success(data);
            vmspreaderoptions.AgentRoles = data.result.AgentRoles;
            vmspreaderoptions.AgentGrades = data.result.AgentGrades;
        });
    },
    bindGradesFilter: function (el) {
        return el.RoleID == vmspreaderoptions.ggOption.RoleID;
    },
    SpreadOptionsSet: [],
    AgentRevenesSet: [],
    getAgentSpreaderOptionList: function () {
        var querystring = '&moduleType=' + vmspreaderoptions.moduleType;
        Du.Get('Spreaderoptions', 'Index', querystring, function (data) {
            MessageBox.success(data);
            vmspreaderoptions.SpreadOptionsSet = data.result.SpreadOptionsSet;
            vmspreaderoptions.AgentRevenesSet = data.result.AgentRevenesSet;
        });
    },
    submit: function (e) {
        var querystring = '&moduleType=' + vmspreaderoptions.moduleType;
        var list, subType;
        if (e === 0) {
            list = vmspreaderoptions.SpreadOptionsSet.$model;
            querystring += '&subType=spreadoptionsset';
        }
        else {
            list = vmspreaderoptions.AgentRevenesSet.$model;
            querystring += '&subType=agentrevenesset';
        }

        var data = JSON.stringify(list);
        Du.PostFormData('Spreaderoptions', 'New', querystring, data, function (data) {
            MessageBox.show(data);
        });
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
    },
    init: function () {
        vmspreaderoptions.getAgentSpreaderOptionList();
    }
});