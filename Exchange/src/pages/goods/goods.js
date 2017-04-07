import { fetchData, postData } from '../../commons/ajax';
import Promise from 'bluebird';

var createGoods = (id, data) => {
        var tmpl = `${data.map(d => `
        <section class="good-group">
            <h1>${d.title}</h1>
            <ul>
                ${d.rows.map(r=>`
                    <li>
                        <a class="good-item clearfix" href="./pay.html?id=${r.GoodID}">
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
    $(id).append(tmpl);
}

var data = [{
    title: 'Hot',
    rows: [
        { GoodID: '001', ImgUrl: './images/1002.png', Price: 50 },
        { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 },
        { GoodID: '003', ImgUrl: './images/1007.png', Price: 50 }
    ]
}, {
    title: '3C',
    rows: [
        { GoodID: '001', ImgUrl: './images/1002.png', Price: 50 },
        { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 },
        { GoodID: '003', ImgUrl: './images/4003.png', Price: 50 }
    ]
}];

var getGoods = () => {
    // fetchData('/goods')

    return new Promise((resolve, reject) => setTimeout(resolve, 500, data));
}

export var initData = () => {
getGoods()
    .then((data) => {
        createGoods('#good-list', data);
    })
}
