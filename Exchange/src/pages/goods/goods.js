import { fetchData, postData } from '../../commons/basic/ajax';
import data from './goods.mock';
import Promise from 'bluebird';


var createGoods = (data) => {
        var tmpl = `${data.map(d => `
        <section class="good-group">
            <h1>${d.title}</h1>
            <ul>
                ${d.rows.map(r=>`
                    <li>
                        <a class="good-item clearfix" href="./gooddetail.html?id=${r.GoodID}">
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
        </section>
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
        if(selectMunuItem===item) return;
        $(selectMunuItem).removeClass('active');
        el.addClass('active');
        selectMunuItem=item;
    });  
}

var initAction = () => {
    ['#btn_home','#btn_category','#btn_shopcar'].forEach((el)=>{
        addClick(el);
    });
}

export var init = () => {
    initData();
    initAction();
}
