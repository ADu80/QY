import { fetchData, postData } from '../../commons/basic/ajax';
import mockData from './orders.mock';
import Promise from 'bluebird';

var createGoods = (data) => {
        var tmpl = `
    ${data.rows.map(o=>`
        <li class="grid-item">
            <dl>
                <dt class="order-item-title">
                    <a><span class="iconfont icon-dingdan"><span><span style="padding-left:.2rem;">兑换单号：${o.OrderCode}</span></a>
                    <span>状态：完成</span>
                </dt>
                <dd class="order-item-goods">
                    ${o.goods.map(g=>`
                    <a data-oid="${o.OrderID}">
                        <img data-gid="${g.GoodID}" src="/images/${g.ImgUrl}">
                    </a>
                    `)}
                </dd>
                <dd class="order-item-sum">
                    <p>共${o.Num}件商品,兑换${formatPayTypeToString(o.payType)}：${o.Amount}</p>
                    <a class="btn">再次兑换</a>
                </dd>
            </dl>
        </li>`
    ).join('')}
    `;
    $('#grid-orders').append(tmpl);
}

var formatPayTypeToString = (type) => {
    switch(type){
        case 1:return '积分';
        case 2:return '金币';
        case 3:return '钻石';
    }
}

var getOrders = () => {
    // fetchData('/goods')

    return new Promise((resolve, reject) => setTimeout(resolve, 300, mockData));
}

var initData = () => {
    getOrders()
        .then((data) => {
            createGoods(data);
        })
        .catch((err)=>{
            alert(err);
        });
}

var initAction = () => {

}

export var init = () => {
    initData();
    initAction();
}
