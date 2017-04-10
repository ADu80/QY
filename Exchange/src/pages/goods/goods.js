import { fetchData, postData } from '../../commons/basic/ajax';
import data from './goods.mock';
import Promise from 'bluebird';

var createGoods = (data) => {
        var tmpl = `${data.map(d => `
            <ul class="grid grid-goods">
                ${d.rows.map(r=>`
                    <li class="grid-item">
                        <a class="good-item" href="./gooddetail.html?id=${r.GoodID}">
                            <img src="${r.ImgUrl}"></img>
                            <dl class="good-info">
                                <dt class="title"><p>Apple MacBook Pro 13.3英寸笔记本电脑 深空灰色</p></dt>
                                <dt class="activity"></dt>
                                <dt class="showprice"><i>${r.Price}</i><span class="iconfont icon-"></span><dt>
                            </dl>
                        </a>
                    </li>`
                ).join('')}
            </ul>
    `).join('')}`;
    $('#good-list').append(tmpl);
}


var getGoods = () => {
    // fetchData('/goods')

    return new Promise((resolve, reject) => setTimeout(resolve, 300, data));
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
