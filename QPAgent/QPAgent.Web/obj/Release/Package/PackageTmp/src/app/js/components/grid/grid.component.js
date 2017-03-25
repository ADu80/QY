avalon.component('ms-grid', {
    template: heredoc(function () {
        /*
        <div class="grid">
            <div class="gridview">
                <slot name="table"></slot>
                <div class="gridview-nodata" ms-visible="@datasource.length===0&&!@onsearching">暂无记录</div>
            </div>
            <div class="pager">
                <p>页码/总页数：<span class="num">{{@pageIndex}}</span>/<span class="num">{{@totalPage}}</span>每页<span class="num">{{@pageSize}}</span>行,共<span class="num">{{@totalCount}}</span>条记录</p>
                <a ms-class="['first',@firstDisabled&&'disabled']" ms-click="@gotoPage(1)">首页</a> 
                <a ms-class="['pre',@preDisabled&&'disabled']" ms-click="@gotoPage(@pageIndex-1)">上一页</a>
                <a ms-class="['next',@nextDisabled&&'disabled']" ms-click="@gotoPage(@pageIndex+1)">下一页</a>
                <a ms-class="['last',@lastDisabled&&'disabled']" ms-click="@gotoPage(@totalPage)">末页</a>
                <input type="text" ms-duplex="@goIndex">
                <a ms-click="@go()">Go</a>
            </div>
        </div>
        */
    }),
    defaults: {
        /********外部注入*****/
        //datasource: [],
        //columns: [],
        onsearching: false,
        fillGrid: function (e) {
            //由onReady调用
        },
        onpagechange: function (e) {
            //由gotoPage调用
            this.fillGrid(e);
        },
        pageIndex: 1,
        pageSize: 20,
        totalPage: 0,
        totalCount: 0,
        /********************/

        gotoPage: function (i) {
            if (i <= 0 || i == this.pageIndex || i > this.totalPage) {
                return;
            }
            var e = { pageIndex: i, pageSize: this.pageSize, cancel: false };
            this.onpagechange(e);
            if (e.cancel) return;
            this.pageIndex = i;
            this.setdisable(i);
        },
        firstDisabled: false,
        preDisabled: false,
        nextDisabled: false,
        lastDisabled: false,
        setdisable: function (i) {
            if (this.totalPage == 0 || this.totalPage == 1) {
                this.firstDisabled = true;
                this.preDisabled = true;
                this.nextDisabled = true;
                this.lastDisabled = true;
            }
            else if (i == 1) {
                this.firstDisabled = true;
                this.preDisabled = true;
                this.nextDisabled = false;
                this.lastDisabled = false;
            }
            else if (i == this.totalPage) {
                this.firstDisabled = false;
                this.preDisabled = false;
                this.nextDisabled = true;
                this.lastDisabled = true;
            }
            else if (i > 1 && i < this.totalPage) {
                this.firstDisabled = false;
                this.preDisabled = false;
                this.nextDisabled = false;
                this.lastDisabled = false;
            }
            else {
                this.firstDisabled = true;
                this.preDisabled = true;
                this.nextDisabled = true;
                this.lastDisabled = true;
            }
        },
        goIndex: 0,
        go: function () {
            this.gotoPage(this.goIndex);
        },
        vmodel: '',
        showsmartmenu: function (vmodel, cb) {
            //var contextmenu_data = [[{
            //    text: "刷新",
            //    func: function () {
            //       cb({ pageIndex: this.page, pageSize: this.pageSize });
            //    }
            //}]];
            //var option = { name: 'grid' };
            //var dom = vmodel ? vmodel + ' .grid' : '.grid';
            //$(dom).smartMenu(contextmenu_data, option);
        },

        /*********begin选择框**************/
        allchecked: false,
        setSkipChecked: function () { },
        checkAll: function (e) {
            console.log('checkAll');
            var checked = e.target.checked
            this.datasource.forEach(function (el) {
                el.checked = checked
            });
            this.setSkipChecked();
        },
        checkOne: function (e) {
            console.log('checkOne');
            var checked = e.target.checked
            if (checked === false) {
                this.allchecked = false
            } else {
                this.allchecked = this.datasource.every(function (el) {
                    return el.checked
                })
            }
        },
        /***********end选择框****************/

        onInit: function (e) {

        },
        onReady: function (e) {
            //加载数据
            var ee = { pageIndex: this.pageIndex, pageSize: this.pageSize }
            //this.fillGrid(ee);

            //右键菜单
            this.showsmartmenu(this.vmodel, this.fillGrid);
            this.setdisable(1);
        },
        onViewChange: function (e) {
            //var ee = { pageIndex: this.pageIndex, pageSize: this.pageSize }
            //this.fillGrid(ee);
            this.setdisable(this.pageIndex);
        }
    }
});