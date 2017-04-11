import { fetchData, postData } from '../../commons/basic/ajax';
import mockData from './goods.mock';
import Promise from 'bluebird';

var createGoods = (data) => {
        var tmpl = `
        ${data.rows.map(r=>`
            <li class="grid-item">
                <a class="good-img-link" href="./gooddetail.html?id=${r.GoodID}">
                    <img src="${r.ImgUrl}"></img>
                </a>
                <dl class="good-info">
                    <dt class="good-info-item title">
                        <p>Apple MacBook Pro 13.3英寸笔记本电脑 深空灰色</p>
                    </dt>
                    <dt class="good-info-item price">
                        <i>￥${r.Price}</i>
                    </dt>
                    <dt class="good-info-item action">
                        <a class="btn" data-gid="${r.GoodID}"><span class="iconfont icon-gouwuche"></span>加入购物车</a>
                        <a class="btn" data-gid="${r.GoodID}" href="pay.html?id=${r.GoodID}"><span class="iconfont icon-danpin"></span>立即兑换</a>                        
                    </dt>
                </dl>
            </li>`
        ).join('')}`;
    $('#grid-goods').append(tmpl);
}


var getGoods = () => {
    // fetchData('/goods')

    return new Promise((resolve, reject) => setTimeout(resolve, 300, mockData));
}

var initData = () => {
    getGoods()
        .then((data) => {
            createGoods(data);
        })
        .catch((err)=>{
            alert(err);
        });
}

var selectMunuItem='#btn_home';

var addClick=(item)=>{
    var el=$(item);
    el.click((e)=>{
        console.log(e);
        if(selectMunuItem===item) return;
        $(selectMunuItem).removeClass('active');
        el.addClass('active');
        selectMunuItem=item;
    });  
}

var initAction = () => {
    ['#btn_home','#btn_history','#btn_shopcar'].forEach((el)=>{
        addClick(el);
    });
}

export var init = () => {
    initData();
    initAction();
}
