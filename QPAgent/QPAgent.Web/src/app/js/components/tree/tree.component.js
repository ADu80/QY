var treeID = 0
avalon.component('tree', {
    template: heredoc(function () {
        /*
        <ul>
            <li ms-for="(index, el) in @tree" ms-class="['item','item-'+el.level,'item-'+el.type]">
                <div class="title">
                    <span ms-class="el.subtree.length?(el.open?'iconfont icon-icon-copy-copy1':'iconfont icon-icon-copy-copy'):'none'" ms-click="@openSubTree(el) | stop"></span>
                    <span class="iconfont icon-ren"></span>
                    <span class="title-text" ms-click="@onTreeNodeSelected(el,$event)" ms-on-contextmenu="@onContextMenu(el,$event)">{{el.title}}</span>
                </div>
                <div ms-visible="el.open" ms-html="@renderSubTree(el)" class="subtree">
                </div>
            </li>
        </ul>
        */
    }),
    defaults: {
        //tree: [],
        renderSubTree: function (el) {
            return el.subtree.length ? '<wbr ms-widget="{is:\'tree\',$id:\'tree_' + (++treeID) + '\',tree:el.subtree,onTreeNodeSelected:@onTreeNodeSelected}" />' : '';
        },
        openSubTree: function (el) {
            el.open = !el.open;
        },
        //contextmenuArr: [],
        //showContextMenu: function (module, data) {
        //    var option = { name: 'tree' };
        //    var menudom;
        //    if (!module) {
        //        menudom = '.tree .item .title .title-text';
        //    }
        //    else {
        //        menudom = module + ' .tree .item .title .title-text';
        //    }
        //    $(menudom).smartMenu(data, option);
        //},
        //onContextMenu: function (el, e) {
        //    $('.tree .item .title').css({ background: 'transparent' });
        //    $('.lev-contextmenu').addClass("visible");
        //    $('.lev-contextmenu').css({ left: e.clientX, top: e.clientY });
        //    return false;
        //},
        onReady: function (e) {
            //this.showContextMenu(this.module, this.contextmenuArr.$model);

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
        }
    }
});
