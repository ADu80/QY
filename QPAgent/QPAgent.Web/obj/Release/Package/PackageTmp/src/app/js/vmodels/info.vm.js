var vmInfo = avalon.define({
    $id: 'vminfo',
    moduleType: 1,
    vmState: 'none',
    tabs: [
        { title: '基本信息', tabpage: 'basic', active: true },
        { title: '玩家列表', tabpage: 'gamerlist', active: false },
        { title: '子代理商', tabpage: 'myagent', active: false }
    ],
    selectedTabIndex: 0,
    selectedTabPage: 'basic',
    onSelectTab: function (i, p) {
        if (vmInfo.selectedTabIndex === i) return;

        vmInfo.tabs[vmInfo.selectedTabIndex].active = false;
        vmInfo.tabs[i].active = true;
        vmInfo.selectedTabIndex = i;
        vmInfo.selectedTabPage = p;
        if (vmInfo.selectedTabPage === 'gamerlist') {
            vmGamerlistInfo.findNew();
        }
        else if (vmInfo.selectedTabPage === 'myagent') {
            vmSubAgentlistInfo.findNew();
        }
    },
    AgentLevelLimits: [{ LevelLimit: 1, LevelLimitDes: '1级' }, { LevelLimit: 2, LevelLimitDes: '2级' }],
    AgentLevelLimitsDisabled: true,
    createAgentLevelLimits: function (limit) {
        vmInfo.AgentLevelLimits.clear();
        for (var i = 1; i < limit; i++) {
            vmInfo.AgentLevelLimits.push({ LevelLimit: i, LevelLimitDes: i + '级' });
        }
    },
    setAgentLevelLimitsDisabled: function (limit) {
        vmInfo.AgentLevelLimitsDisabled = (limit <= 2 ? true : false);
    },
    newUser: { UserID: -1, UserName: '', Nick: '', Sex: 1, Password: '123456', cfPassword: '123456', canHasSub: 0, AgentLevelLimit: 1, Revenue: '', RoleID: -1, GradeID: -1 },
    editUser: { UserID: -1, UserName: '', Nick: '', Sex: 1, canHasSub: 0, AgentLevelLimit: '', Revenue: '', AgentStatus: 0, RoleID: -1, GradeID: -1 },
    clearNewUser: function () {
        vmInfo.newUser = { UserID: -1, UserName: '', Nick: '', Sex: 1, Password: '', cfPassword: '', canHasSub: 0, AgentLevelLimit: '', Revenue: '', RoleID: -1 };
    },
    loadTree: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=tree&UserID=' + app.LoginUser.UserID;
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            MessageBox.success(data);
            vmInfo.tree = data.result.tree;
        });
    },
    AdminStatInfo: { Allcount: 0, AgentCount: '', PlatformCount: 0, TopAgentCount: 0, SubAgentCount: 0, OnLineCount: 0, AgentOnLineCount: 0, PlatformOnLineCount: 0, Recharge: 0, AgentRecharge: 0, PlatformRecharge: 0, Waste: 0, AgentWaste: 0, PlatformWaste: 0, Score: 0, AgentScore: 0, PlatformScore: 0 },
    findAdminStatInfo: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            if (data.result.data) {
                vmInfo.AdminStatInfo = data.result.data.info[0];
            }
        });
        return false;
    },
    AgentStatInfo: { GameID: 0, Accounts: '', NickName: '', DirectGamerWaste: 0, DirectGamerScore: 0, OnLineCount: 0, OnLineCount: 0, DirectGamerCount: 0, DirectAgentCount: 0, AgentStatus: 0, AllGamerWaste: 0, AllGamerScore: 0, Recharge: 0, AllGamerCount: 0, AllAgentCount: 0, AgentLevelLimit: '', ProfitRate: 0, canHasSubAgent: 0, SpreaderDate: '' },
    findAgentStatInfo: function (UserID) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        if (UserID) {
            querystring += '&UserID=' + UserID;
        }
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            MessageBox.success(data);
            if (data.result.data) {
                vmInfo.AgentStatInfo = data.result.data.info[0];
            }
        });
        return false;
    },
    roleChange: function (e) {
        var roleid = e.target.value;
        vmInfo.newUser.RoleID = roleid;
        vmInfo.editUser.RoleID = roleid;
        var roles = vmInfo.roles.$model.slice();
        var r = roles.filter(function (el) {
            return el.RoleID === roleid;
        });
        var level = r[0].AgentLevel;
        var model = 'newUser';
        if (vmInfo.vmState === 'edit') {
            model = 'editUser';
        }

        if (level <= 1) {
            vmInfo[model].canHasSub = 1;
            vmInfo[model].AgentLevelLimit = 2;
            vmInfo.AgentLevelLimitsDisabled = false;
        }
        else {
            vmInfo[model].canHasSub = 0;
            vmInfo[model].AgentLevelLimit = 1;
            vmInfo.AgentLevelLimitsDisabled = true;
        }

    },
    addUser: function (e, controller, querystring, cbFunc) {
        var data = $(e.target).serialize();
        if (vmInfo.newUser.UserName == '') {
            alert('账号不能为空！');
            return;
        }
        Du.PostFormData(controller, 'New', querystring, data, function (data) {
            if (cbFunc) { cbFunc(); }
            vmInfo.resetData(data);
        });
    },
    addGamerSubmit: function (e) {
        vmInfo.newUser.Password = '';
        vmInfo.newUser.cfPassword = '';
        vmInfo.addUser(e, 'Gamer', '', vmInfo.closeGamerDialog);
    },
    addAgentSubmit: function (e) {
        if (vmInfo.newUser.Revenue === '') {
            alert('盈利税收不能为空！');
            return;
        }
        var querystring = '&IsAgent=' + vmInfo.selectedTreeNode.IsAgent;
        vmInfo.addUser(e, 'SubAgents', querystring, vmInfo.closeAgentDialog);
    },
    editAgentSubmit: function (e) {
        var data = $(e.target).serialize();
        var querystring = "&AdminID=" + vmInfo.selectedTreeNode.AdminID;
        Du.PostFormData('SubAgents', 'Edit', querystring, data, function (data) {
            vmInfo.resetData(data);
            vmInfo.closeSettingDialog();
        });
    },
    resetData: function (data) {
        if (data.status === "success") {
            vmInfo.loadTree();
            vmInfo.findAdminStatInfo();
            vmInfo.findAgentStatInfo(vmInfo.selectedTreeNode.id);
            vmInfo.showAgentSmartMenuLi = false;
            vmInfo.showGamerSmartMenuLi = false;
            vmInfo.showSettingSmartMenuLi = false;
            vmInfo.clearNewUser();
        }
        MessageBox.show(data);
    },
    //SpreaderIdChoiceVisible: false,
    SpreaderIDList: [],
    getTopSpreader: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=spreaderidlist';
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            MessageBox.success(data);
            vmInfo.SpreaderIDList = data.message;
        });
    },
    CodeID: -1,
    //chooseSpreaderID: function (codeId, e) {
    //    vmInfo.CodeID = codeId;
    //    $('.choice.choice-spreaderid span').removeClass('selected');
    //    $(e.currentTarget).addClass('selected');
    //},
    openSpreaderIdChoice: function (e, i) {
        vmInfo.getTopSpreader();
        //vmInfo.SpreaderIdChoiceVisible = true;
        $('#txtSpreaderID' + (i == 2 ? '2' : '')).addClass('visible');
        $('#txtSpreaderID' + (i == 2 ? '2' : '')).focus();
        $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).removeClass('visible');
        var code = $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).text();
        $('#txtSpreaderID' + (i == 2 ? '2' : '')).val(code);
        vmInfo.CodeID = code;
        //$('.choice.choice-spreaderid').css({ zIndex: 2000 });
        //$('.choice.choice-spreaderid span').removeClass('selected');
        vmInfo.saveBtnVisible = true;
        vmInfo.openBtnVisible = false;
    },
    closeSpreaderIdChoice: function (i) {
        //vmInfo.SpreaderIdChoiceVisible = false;
        $('#txtSpreaderID' + (i == 2 ? '2' : '')).removeClass('visible');
        $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).addClass('visible');
        vmInfo.saveBtnVisible = false;
        vmInfo.openBtnVisible = true;
    },
    changeSpreaderID: function (e) {
        vmInfo.CodeID = $(e.currentTarget).val();
    },
    openBtnVisible: true,
    saveBtnVisible: false,
    saveSpreaderID: function (e, i) {
        var code = vmInfo.CodeID.trim();
        if (!/^[A-Za-z0-9]{3,6}$/.test(code)) {
            alert('格式不正确,邀请码只能由3-6个字母数字组成！');
            vmInfo.closeSpreaderIdChoice();
            return false;
        }
        var oldCode = $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).text();
        if (oldCode === code) {
            vmInfo.closeSpreaderIdChoice();
            return false;
        }
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=spreaderid&UserID=' + vmInfo.selectedTreeNode.id + '&UserName='
            + vmInfo.selectedTreeNode.UserName + '&SpreaderID=' + code + '&oldSpreaderID=' + oldCode,
        Du.PostEx('SubAgents', 'Edit', querystring, function (data) {
            $('#txtSpreaderID' + (i == 2 ? '2' : '')).removeClass('visible');
            $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).addClass('visible');
            vmInfo.openBtnVisible = true;
            vmInfo.saveBtnVisible = false;
            if (data.status == 'success') {
                vmInfo.AgentStatInfo.SpreaderID = code;
            }
            $('#txtSpreaderID' + (i == 2 ? '2' : '')).val('');
        }, function (err) {
            $('#txtSpreaderID' + (i == 2 ? '2' : '')).removeClass('visible');
            $('#AgentStatInfo-SpreaderID' + (i == 2 ? '2' : '')).addClass('visible');
            MessageBox.error(err.responseText);
        }
    );
        return false;
    },
    copySpreaderURL: function (event, id) {
        var succ = copyToClipboard(document.getElementById(id));
        if (succ) {
            alert('成功复制到剪切板！');
        }
    },
    agentAnimation: 'enter',
    gamerAnimation: 'enter',
    settingAnimation: 'enter',
    openAgentDialog: function (e) {
        vmInfo.newUser.Password = '123456';
        vmInfo.newUser.cfPassword = '123456';
        vmInfo.agentAnimation = 'leave';
    },
    openGamerDialog: function (e) {
        vmInfo.gamerAnimation = 'leave';
    },
    openSettingDialog: function (e) {
        vmInfo.settingAnimation = 'leave';
    },
    closeAgentDialog: function (e) {
        vmInfo.agentAnimation = 'enter';
        vmInfo.resetSmartMenu();
    },
    closeGamerDialog: function (e) {
        vmInfo.gamerAnimation = 'enter';
        vmInfo.resetSmartMenu();
    },
    closeSettingDialog: function (e) {
        vmInfo.settingAnimation = 'enter';
        vmInfo.resetSmartMenu();
    },
    showAgentSmartMenuLi: false,
    showGamerSmartMenuLi: false,
    showSettingSmartMenuLi: false,
    showCanHasSubAgent: false,
    resetSmartMenu: function () {
        vmInfo.vmState = "none";
        vmInfo.showAgentSmartMenuLi = false;
        vmInfo.showGamerSmartMenuLi = false;
        vmInfo.showSettingSmartMenuLi = false;
    },
    selectedTreeNode: { id: -1, parentId: -1, AdminID: -1, UserName: '', IsAgent: false, ParentsAgentLevelCount: 0, AgentLevelLimit: 0 },
    tree: [],
    renderSubTree: function (el) {
        if (!el.subtree) return '';
        return el.subtree.length ? '<ul><li ms-for="(index, el) in el.subtree" ms-class="[\'item\',\'item-\'+el.ag,\'item-l-\'+el.level,\'item-\'+el.type]"><div class="title"><span ms-class="el.subtree.length?(\'iconfont \'+(el.open?\'icon-rightdown\':\'icon-right\')):\'none\'" ms-click="@openSubTree(el) | stop"></span><span class="iconfont icon-ren"></span><span class="title-text" ms-click="@onTreeNodeSelected(el,$event)" ms-on-contextmenu="@onContextMenu(el,$event)">{{el.title}}<span class="rolename" ms-on-contextmenu="@onContextMenu(el,$event)">{{el.GradeDes}}</span></span></div><div ms-visible="el.open" ms-html="@renderSubTree(el)" class="subtree"></div></li></ul>' : '';
    },
    openSubTree: function (el) {
        el.open = !el.open;
    },
    //////////////////////////////////////////////////////////////////////////////////////////////
    onTreeNodeSelected: function (el, e) {
        $('.tree .item .title').css({ background: 'transparent' });
        $(e.target).parents('.title').css({ background: '#8ce' });
        vmInfo.newUser.RoleID = el.RoleID;
        vmGamerlistInfo.condition.byUserID = el.id;
        vmSubAgentlistInfo.condition.byUserID = el.id;

        if (vmInfo.selectedTreeNode.id != el.id) {
            vmInfo.selectedTreeNode.id = el.id;
            vmInfo.selectedTreeNode.RoleID = el.RoleID;
            vmInfo.selectedTreeNode.UserName = el.title;
            vmInfo.selectedTreeNode.AdminID = el.AdminID;
            vmInfo.selectedTreeNode.parentId = el.parentId;
            vmInfo.selectedTreeNode.IsAgent = el.type == 'agent' ? true : false;
            vmInfo.closeSpreaderIdChoice(1);
            vmInfo.closeSpreaderIdChoice(2);
            if (el.type == 'admin') {
                vmInfo.findAdminStatInfo();
                //vmGamerlistInfo.find();
                //vmSubAgentlistInfo.find();
            } else {
                vmInfo.findAgentStatInfo(el.id);
                //vmGamerlistInfo.find();
                //vmSubAgentlistInfo.find();
            }
            if (vmInfo.selectedTabPage === 'gamerlist') {
                vmGamerlistInfo.find();
            } else {
                vmGamerlistInfo.IsFind = 0;
            }
            if (vmInfo.selectedTabPage === 'myagent') {
                vmSubAgentlistInfo.find();
            } else {
                vmSubAgentlistInfo.IsFind = 0;
            }

        }
        vmInfo.reportDialog.UserID = el.id;
        vmInfo.reportDialog.userType = el.type;
        vmInfo.reportDialog.title = '代理商基本数据 - ' + el.title;
    },
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    onContextMenu: function (el, e) {
        $('.tree .item .title').css({ background: 'transparent' });
        $(e.target).parents('.title').css({ background: '#8ce' });
        $('.lev-contextmenu').addClass("visible");
        $('.lev-contextmenu').css({ left: e.clientX, top: e.clientY });
        $('.lev-contextmenu .item *').css({ color: "#ccc" });
        $('.lev-contextmenu .item.item-refresh *').css({ color: "#111" });

        if (app.LoginUser.IsAgent) {
            if (el.AdminID == app.LoginUser.UserID) {
                if (el.canHasSubAgent) {
                    $('.lev-contextmenu .item-agent *').css({ color: "#111" });
                    vmInfo.showAgentSmartMenuLi = true;
                    //vmInfo.createAgentLevelLimits(el.AgentLevelLimit);
                    //vmInfo.setAgentLevelLimitsDisabled(el.AgentLevelLimit);
                }
                $('.lev-contextmenu .item-gamer *').css({ color: "#111" });
                vmInfo.showGamerSmartMenuLi = true;
                vmInfo.showSettingSmartMenuLi = false;
            }
            else if (app.LoginUser.AgentID = el.parentId) {
                $('.lev-contextmenu .item-setting *').css({ color: "#111" });
                vmInfo.showAgentSmartMenuLi = false;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = true;
            }
            else {
                $('.lev-contextmenu .item *').css({ color: "#ccc" });
                vmInfo.showAgentSmartMenuLi = false;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = false;
            }
        }
        else {
            if (el.AdminID == app.LoginUser.UserID) {
                $('.lev-contextmenu .item-agent *').css({ color: "#111" });
                vmInfo.showAgentSmartMenuLi = true;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = false;
                vmInfo.AgentLevelLimitsDisabled = false;
            }
            else if (el.parentId == 0) {
                $('.lev-contextmenu .item-setting *').css({ color: "#111" });
                vmInfo.showAgentSmartMenuLi = false;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = true;
            }
            else {
                $('.lev-contextmenu .item *').css({ color: "#ccc" });
                vmInfo.showAgentSmartMenuLi = false;
                vmInfo.showGamerSmartMenuLi = false;
                vmInfo.showSettingSmartMenuLi = false;
            }
        }

        vmInfo.newUser.UserID = el.id;
        vmInfo.newUser.RoleID = el.RoleID;
        vmInfo.selectedTreeNode.id = el.id;
        vmInfo.selectedTreeNode.RoleID = el.RoleID;
        vmInfo.selectedTreeNode.UserName = el.title;
        vmInfo.selectedTreeNode.AdminID = el.AdminID;
        vmInfo.selectedTreeNode.parentId = el.parentId;
        vmInfo.selectedTreeNode.IsAgent = el.type == 'agent' ? true : false;
        return false;
    },
    reportDialog: { UserID: -1, userType: 'admin', title: '基本数据' },
    spreadsumDialog: { title: '基本数据' },
    gamerDetail: { GameID: '', Accounts: '', NickName: '', InviteCode: '', LoginStatus: '', Experience: 0, Level: 0, Score: 0, InsureScore: 0, Diamond: 0, RCard: 0, GamerSpreaderSum: 0, LoginTimes: 0, RegisterIP: '', SpreaderDate: '', LastLogonIP: '', LastLogonDate: '' },
    openReport: function (row, userType) {
        //vmInfo.reportVisible = true;
        vmInfo.reportAnimation = 'leave';

        if (row) {
            vmInfo.reportDialog.UserID = row.UserID;
            vmInfo.reportDialog.userType = userType;
            vmInfo.reportDialog.title = '玩家基本数据 - ' + '' + row['GameID'] + '(' + row['NickName'] + ')';
            var gd = vmInfo.gamerDetail.$model;
            for (var i in gd) {
                $('#gamerDetail-' + i.toString()).text(row[i]);
            }
        }
    },
    closeReport: function () {
        //vmInfo.reportVisible = false;
        vmInfo.reportAnimation = 'enter';

        vmInfoReport.setReportView('basic');
        vmInfo.reportDialog.UserID = vmInfo.selectedTreeNode.id;
        vmInfo.reportDialog.userType = vmInfo.selectedTreeNode.IsAgent ? 'agent' : 'admin';
        vmInfo.reportDialog.title = '基本数据';
        vmInfoReport.closeRelationDialog();
    },
    reportVisible: false,
    reportAnimation: 'enter',
    setReportVisible: function () {
        //vmInfo.reportVisible = !vmInfo.reportVisible;
        vmInfo.reportAnimation = 'leave';
    },
    checkIds: function () {
        var ids;
        if (vmInfo.selectedTabPage == 'gamerlist') {
            ids = vmGamerlistInfo.checkIds();
        }
        else if (vmInfo.selectedTabPage == 'myagent') {
            ids = vmSubAgentlistInfo.checkIds();
        }
        return ids;
    },
    AddGiftGold: function (e) {
        if (vmInfo.GiftGoldForm.GiftGold.trim() === "") {
            alert('请输入金币数量！');
            return false;
        }
        if (vmInfo.GiftGoldForm.Reason.trim() === "") {
            alert('请输入赠送原因！');
            return false;
        }
        var ids = vmInfo.checkIds();
        var querystring = '&moduleType=' + vmadmin.moduleType + '&IsAgent=' + app.LoginUser.IsAgent;
        var data = '&ids=' + ids + '&GiftGold=' + vmInfo.GiftGoldForm.GiftGold + '&Reason=' + vmInfo.GiftGoldForm.Reason;
        Du.PostFormData('RecordGrantTreasure', 'New', querystring, data, function (data) {
            vmInfo.refreshDatasource();
            vmInfo.closeGiveGoldDialog();
            MessageBox.show(data);
        });
        return false;
    },
    AddRCard: function (e) {
        if (vmInfo.GiftRCardForm.RCard.trim() === "") {
            alert('请输入房卡数量！');
            return false;
        }
        if (vmInfo.GiftRCardForm.Reason.trim() === "") {
            alert('请输入赠送原因！');
            return false;
        }
        var ids = vmInfo.checkIds();
        var querystring = '&moduleType=' + vmadmin.moduleType + '&IsAgent=' + app.LoginUser.IsAgent;
        var data = '&ids=' + ids + '&RCard=' + vmInfo.GiftRCardForm.RCard + '&Reason=' + vmInfo.GiftGoldForm.Reason;
        Du.PostFormData('RecordGrantRCard', 'New', querystring, data, function (data) {
            vmInfo.refreshDatasource();
            vmInfo.closeGiveRCardDialog();
            MessageBox.show(data);
        });
        return false;
    },
    refreshDatasource: function () {
        if (vmInfo.selectedTabPage === 'gamerlist') {
            vmGamerlistInfo.find();
        }
        else {
            vmSubAgentlistInfo.find();
        }
    },
    GiveGoldDialogVisible: false,
    GiveRCardDialogVisible: false,
    GiveGoldDialogAnimation: 'enter',
    GiveRCardDialogAnimation: 'enter',
    showGiveGoldDialog: function () {
        if (!vmInfo.checkIds()) {
            alert('请勾选行！');
            return;
        }
        //vmInfo.GiveGoldDialogVisible = !vmInfo.GiveGoldDialogVisible;
        vmInfo.GiveGoldDialogAnimation = "leave";
    },
    closeGiveGoldDialog: function () {
        vmInfo.GiveGoldDialogAnimation = "enter";
        vmInfo.GiftGoldForm = { GiftGold: 0, Reason: '' };
    },
    showGiveRCardDialog: function () {
        if (!vmInfo.checkIds()) {
            alert('请勾选行！');
            return;
        }
        //vmInfo.GiveRCardDialogVisible = !vmInfo.GiveRCardDialogVisible;
        vmInfo.GiveRCardDialogAnimation = "leave";
    },
    closeGiveRCardDialog: function () {
        vmInfo.GiveRCardDialogAnimation = "enter";
        vmInfo.GiftRCardForm = { RCard: 0, Reason: '' };
    },
    roles: [],
    grades: [],
    GradeIDFilter: function (el) {
        if (vmInfo.vmState == 'add')
            return vmInfo.newUser.RoleID === el.RoleID;
        else
            return vmInfo.editUser.RoleID === el.RoleID;
    },
    getAddAgentBindData: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=add_binddata&AgentLevel=' + app.LoginUser.AgentLevel;
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            vmInfo.roles = data.result.AgentRoles;
            var roleid = data.result.AgentRoles[0].RoleID;
            vmInfo.roleChange({ target: { value: roleid } });
            if (vmInfo.vmState == 'add') {
                vmInfo.newUser.RoleID = roleid
            }
            else {
                vmInfo.editUser.RoleID = roleid;
            }
            vmInfo.grades = data.result.AgentGrades;
        });
    },
    init: function () {
        vmInfo.loadTree();
        //vmGamerlistInfo.find();
        //vmSubAgentlistInfo.find();
        vmInfoReport.loadReportBind();

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //右键菜单
        $('.lev-contextmenu .item').hover(function () {
            $(this).find('.sub').addClass('visible');
        });
        $('.lev-contextmenu .item').mouseleave(function () {
            $(this).find('.sub').removeClass('visible');
        });
        $('.lev-contextmenu .sub .item .title').click(function () {
            $('.lev-contextmenu').removeClass("visible");
        });
        $('body').click(function () {
            $('.lev-contextmenu').removeClass("visible");
        });
        $('.lev-contextmenu .item-agent .action').click(function () {
            //代理 - 新增
            if (!vmInfo.showAgentSmartMenuLi) {
                $('.lev-contextmenu').removeClass("visible");
                return false;
            }
            vmInfo.getAddAgentBindData();
            vmInfo.openAgentDialog();
            vmInfo.vmState = "add";
            $('.lev-contextmenu').removeClass("visible");
            return false;
        });
        $('.lev-contextmenu .item-gamer .action').click(function () {
            //玩家 - 新增
            if (!vmInfo.showGamerSmartMenuLi) {
                $('.lev-contextmenu').removeClass("visible");
                return false;
            }
            vmInfo.openGamerDialog();
            vmInfo.vmState = "add";
            $('.lev-contextmenu').removeClass("visible");
            return false;
        });
        $('.lev-contextmenu .item-setting .action').click(function () {
            //设置 - 属性
            if (!vmInfo.showSettingSmartMenuLi) {
                $('.lev-contextmenu').removeClass("visible");
                return false;
            }
            vmInfo.getAddAgentBindData();
            vmInfo.openSettingDialog();
            vmInfo.vmState = "edit";
            $('.lev-contextmenu').removeClass("visible");

            var url = '/ajaxControllers.ashx?controller=SubAgents&type=Index&subType=byId&UserID=' + vmInfo.selectedTreeNode.id;

            $.ajax({
                url: url,
                method: 'GET',
                success: function (data) {
                    MessageBox.success(data);
                    var eu = data.result[0];
                    if (eu) {
                        if (vmInfo.selectedTreeNode.IsAgent)
                            eu.canHasSub = (eu.canHasSub == 'False' ? 0 : 1);
                        vmInfo.editUser = eu;
                    }
                },
                error: function (err) {
                    MessageBox.error(err.responseText);
                }
            })
            return false;
        });
        $('.lev-contextmenu .item-refresh').click(function () {
            vmInfo.loadTree();
        });
    },
    spreadSumDialogVisible: false,
    spreadsumAnimation: 'enter',
    openSpreadSumDialog: function (r) {
        //vmInfo.spreadSumDialogVisible = true;
        vmInfo.spreadsumAnimation = 'leave';
        vmInfo.spreadsumDialog.title = '玩家今日返利明细 - ' + r.GameID + '(' + r.NickName + ')';
        vmInfoSpreadSum.selectedDate = new Date().Format('yyyy-MM-dd');
        vmInfoSpreadSum.loadData(r.UserID);
    },
    closeSpreadSumDialog: function () {
        vmInfo.spreadsumAnimation = 'enter';
    },
    gridsorticon: false,
    toggleGridSortBtn: function () {
        vmInfo.gridsorticon = !vmInfo.gridsorticon;
    },
    GiftGoldForm: { GiftGold: 0, Reason: '' },
    GiftRCardForm: { RCard: 0, Reason: '' },
    checkSensitive: function (e) {
        var word = e.target.value.trim();
    }
});
vmInfo.$watch('onReady', function () {
    setTimeout(function () {
        $('input[data-date="datepicker"]').datepicker({
            format: 'yyyy-mm-dd'
        });
    });
    vmInfo.onTreeNodeSelected(vmInfo.tree[0], { target: '.tree li.item-admin>.title .title-text' });
});
vmInfo.$watch('tree', function () {
    if (!app.LoginUser.IsAgent) {
        //vmInfo.onTreeNodeSelected(vmInfo.tree[0], { target: '.tree li.item-admin .title .title-text' });
    }
});