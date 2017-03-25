var vmInfoSpreadSum = avalon.define({
    $id: 'vmInfoSpreadSum',
    moduleType: 1,
    AData: [],
    BData: [],
    CData: [],
    UserID: -1,
    selectedDate: '',
    loadData: function (UserID) {
        vmInfoSpreadSum.UserID = UserID;
        var querystring = '&moduleType=' + vmadmin.moduleType;
        querystring += '&subType=spreadsum&UserID=' + UserID + '&today=' + vmInfoSpreadSum.selectedDate;
        Du.Loading('MyInfo', 'Index', querystring, function (data) {
            vmInfoSpreadSum.AData = data.result.A;
            vmInfoSpreadSum.BData = data.result.B;
            vmInfoSpreadSum.CData = data.result.C;
            vmInfoSpreadSum.RealSpreadSum = data.result.RealSpreadSum;

            vmInfoSpreadSum.SumData(['A', 'B', 'C'], 'TodayWaste', 'WasteSum');
            vmInfoSpreadSum.SumData(['A', 'B', 'C'], 'TodayCommission', 'SpreadSum');
        });
    },
    loadDataByDate: function (e) {
        vmInfoSpreadSum.loadData(vmInfoSpreadSum.UserID);
    },
    SumData: function (types, prop, sumprop) {
        for (var t in types) {
            var type = types[t];
            var sum = 0;
            var data = vmInfoSpreadSum[type + 'Data'].$model;
            for (var i in data) {
                sum += (+data[i][prop]);
            }
            vmInfoSpreadSum[type + sumprop] = sum;
        }
    },
    RealSpreadSum: 0,
    AWasteSum: 0,
    BWasteSum: 0,
    CWasteSum: 0,
    ASpreadSum: 0,
    BSpreadSum: 0,
    CSpreadSum: 0
});
