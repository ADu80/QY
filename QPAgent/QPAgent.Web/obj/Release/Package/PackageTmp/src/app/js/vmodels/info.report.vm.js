var vmInfoReport = avalon.define({
    $id: 'vmInfoReport',
    moduleType: 1,
    reportView: 'basic',
    setReportView: function (view) {
        vmInfoReport.reportView = view;
        switch (view) {
            case 'basic':
                break;
            case 'richchange':
                vmInfoReport.findRichChange();
                break;
            case 'recharge':
                vmInfoReport.findRecharge();
                break;
            case 'loginlog':
                vmInfoReport.findLoginLog();
                break;
            case 'gift':
                vmInfoReport.findGift();
                break;
            case 'playgame':
                vmInfoReport.findPlayGame();
                break;
            case 'gamewaste':
                vmInfoReport.findGameWaste();
                break;
            case 'allsum':
                if (vmInfo.reportDialog.userType == 'gamer') {
                    vmInfoReport.findAllSum_Gamer();
                }
                else {
                    vmInfoReport.findAllSum();
                }
                break;
            case 'allplayer':
                vmInfoReport.findSpreadPlayer();
                break;
            default:
                break;
        }
    },
    datasource: [],
    config: {
        totalCount: 0,
        totalPage: 0,
        pageIndex: 1,
        pageSize: 20
    },
    onRowChanged: function (e) {
    },
    Cond_Recharge: { Accounts: '', Range: -1, startDate: '', endDate: '' },
    Cond_Gift: { Accounts: '', OperationType: -1, startDate: '', endDate: '' },
    Cond_LoginLog: { startDate: '', endDate: '' },
    Cond_Rich: { rType: -1, startDate: '', endDate: '' },
    Cond_PlayGame: { GameID: -1, RoomID: -1, Accounts: '', startDate: '', endDate: '' },
    Cond_GameWaste: { GameID: -1, startDate: '', endDate: '' },
    Cond_AllSum: { startDate: '', endDate: '' },
    Cond_AllSum_Gamer: { startDate: '', endDate: '' },
    Cond_AllPlayer: { startDate: '', endDate: '' },
    Cond_AllPlayer_Gamer: { startDate: '', endDate: '' },
    ClearRechargeCond: function () {
        vmInfoReport.Cond_Recharge = { Accounts: '', Range: -1, startDate: '', endDate: '' };
    },
    ClearGiftCond: function () {
        vmInfoReport.Cond_Gift = { Accounts: '', OperationType: -1, startDate: '', endDate: '' };
    },
    ClearLoginLogCond: function () {
        vmInfoReport.Cond_LoginLog = { Accounts: '', OperationType: -1, startDate: '', endDate: '' };
    },
    ClearRichCond: function () {
        vmInfoReport.Cond_Rich = { rType: -1, startDate: '', endDate: '' };
    },
    ClearPlayGameCond: function () {
        vmInfoReport.Cond_PlayGame = { GameID: -1, RoomID: -1, Accounts: '', startDate: '', endDate: '' };
    },
    ClearGameWasteCond: function () {
        vmInfoReport.Cond_GameWaste = { GameID: -1, startDate: '', endDate: '' };
    },
    ClearAllSumCond: function () {
        vmInfoReport.Cond_AllSum = { startDate: '', endDate: '' };
    },
    ClearAllSum_GamerCond: function () {
        vmInfoReport.Cond_AllSum_Gamer = { startDate: '', endDate: '' };
    },
    ClearAllPlayerCond: function () {
        vmInfoReport.Cond_AllPlayer = { startDate: '', endDate: '' };
    },
    ClearAllPlayer_GamerCond: function () {
        vmInfoReport.Cond_AllPlayer_Gamer = { startDate: '', endDate: '' };
    },
    findRecharge: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getRecharge({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findGift: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getGift({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findLoginLog: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getLoginLog({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findRichChange: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getRichChange({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findPlayGame: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getPlayGame({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findGameWaste: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getGameWaste({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findAllSum: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getAllSum({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findAllSum_Gamer: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getAllSum_Gamer({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    findSpreadPlayer: function () {
        vmInfoReport.config.pageIndex = 1;
        vmInfoReport.getSpreadPlayer({ pageIndex: 1, pageSize: vmInfoReport.config.pageSize });
    },
    getRecharge: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=recharge';
        querystring += '&Accounts=' + vmInfoReport.Cond_Recharge.Accounts;
        querystring += '&Range=' + vmInfoReport.Cond_Recharge.Range;
        querystring += '&startDate=' + vmInfoReport.Cond_Recharge.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_Recharge.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getGift: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=gift';
        querystring += '&Accounts=' + vmInfoReport.Cond_Gift.Accounts;
        querystring += '&OperationType=' + vmInfoReport.Cond_Gift.OperationType;
        querystring += '&startDate=' + vmInfoReport.Cond_Gift.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_Gift.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getLoginLog: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=loginlog';
        querystring += '&startDate=' + vmInfoReport.Cond_LoginLog.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_LoginLog.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getRichChange: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=richchange';
        querystring += '&rType=' + vmInfoReport.Cond_Rich.rType;
        querystring += '&startDate=' + vmInfoReport.Cond_Rich.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_Rich.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getPlayGame: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=playgame';
        querystring += '&GameID=' + vmInfoReport.Cond_PlayGame.GameID;
        querystring += '&RoomID=' + vmInfoReport.Cond_PlayGame.RoomID;
        querystring += '&Accounts=' + vmInfoReport.Cond_PlayGame.Accounts;
        querystring += '&startDate=' + vmInfoReport.Cond_PlayGame.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_PlayGame.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getGameWaste: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=gamewaste';
        querystring += '&GameID=' + vmInfoReport.Cond_GameWaste.GameID;
        querystring += '&startDate=' + vmInfoReport.Cond_GameWaste.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_GameWaste.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getAllSum: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=allsum';
        querystring += '&startDate=' + vmInfoReport.Cond_AllSum.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_AllSum.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getAllSum_Gamer: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring = '&subType=allsum_gamer';
        querystring += '&startDate=' + vmInfoReport.Cond_AllSum_Gamer.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_AllSum_Gamer.endDate;
        querystring += '&userType=' + vmInfo.reportDialog.userType;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    getSpreadPlayer: function (e) {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=spreadplayer';
        querystring += '&startDate=' + vmInfoReport.Cond_AllPlayer.startDate;
        querystring += '&endDate=' + vmInfoReport.Cond_AllPlayer.endDate;
        querystring += '&byUserID=' + vmInfo.reportDialog.UserID;
        querystring += '&pageIndex=' + e.pageIndex;
        querystring += '&pageSize=' + e.pageSize;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.datasource = data.result.data;
            vmInfoReport.config.totalPage = data.result.totalPage;
            vmInfoReport.config.totalCount = data.result.totalCount;
        });
    },
    GameItems: [],
    RoomList: [],
    loadReportBind: function () {
        var querystring = '&moduleType=' + vmadmin.moduleType;
        var querystring = '&subType=reportbind';
        Du.Get('MyInfo', 'Index', querystring, function (data) {
            vmInfoReport.GameItems = data.result.data.gamelist;
            vmInfoReport.RoomList = data.result.data.roomlist;
            vmInfoReport.getRoomList(-1);
        });
    },
    RoomListFilter: [],
    getRoomList: function (gameid) {
        var rlist = vmInfoReport.RoomList.$model;
        vmInfoReport.RoomListFilter.clear();
        if (gameid == -1) {
            for (var i in rlist) {
                vmInfoReport.RoomListFilter.push(rlist[i]);
            }
            return;
        }
        var roomArr = [];
        for (var i in rlist) {
            if (rlist[i].GameID === gameid) {
                vmInfoReport.RoomListFilter.push(rlist[i]);
            }
        }
    },
    selectGameChange: function (e) {
        var gameid = e.target.value;
        vmInfoReport.Cond_PlayGame.GameID = gameid;
        vmInfoReport.getRoomList(gameid);
    },
    relationText: '',
    relationDialogVisible: false,
    relationDialogStyle: { left: 0, top: 0, right: 0, bottom: 0, margin: 'auto' },
    showRelationDialog: function (e, r) {
        //vmInfoReport.relationDialogStyle = { left: e.clientX, top: e.clientY };
        vmInfoReport.relationText = r.Relation2;
        vmInfoReport.relationDialogVisible = true;
    },
    closeRelationDialog: function (e) {
        vmInfoReport.relationDialogVisible = false;
    },
    sortDesc: function (col) {
        if (vmInfoReport.selectedRowIndex !== -1) {
            vmInfoReport.datasource[vmInfoReport.selectedRowIndex].selected = false;
        }
        vmInfoReport.datasource.sort(function (a, b) {
            if (col == 'RechargeDate' || col == 'LoginTime' || col == 'LogoutTime' || col == 'GiftDate' || col == 'RecordTime' || col == 'StartDate') {
                return new Date(a[col]) < new Date(b[col]);
            }
            return a[col] < b[col];
        });

    },
    sortAsc: function (col) {
        if (vmInfoReport.selectedRowIndex !== -1) {
            vmInfoReport.datasource[vmInfoReport.selectedRowIndex].selected = false;
        }
        vmInfoReport.datasource.sort(function (a, b) {
            if (!isNaN(a[col])) {

            }
            if (col == 'RechargeDate' || col == 'LoginTime' || col == 'LogoutTime' || col == 'GiftDate' || col == 'RecordTime' || col == 'StartDate') {
                return new Date(a[col]) > new Date(b[col]);
            }
            return a[col] > b[col];
        })
    }
});