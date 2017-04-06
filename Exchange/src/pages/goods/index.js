// var $ = jQuery = require('jquery');
function createGoods(id, data) {
    var tmpl = `${data.map(d => `
        <section>
            <h3>${d.title}</h3>
            <ul>
                ${d.rows.map(r=>`
                    <li>
                        <a href="./pay.html?id=${r.GoodID}">
                            <img src="${r.ImgUrl}"></img>
                            <i>${r.Price}</i>
                        </a>
                    </li>`
                ).join('')}
            </ul>
        </section>
    `).join('')}`;
    $(id).append(tmpl);
}


var data=[{
    title:'Hot',
    rows:[
        {GoodID:'001',ImgUrl:'./images/1002.png',Price:50},
        {GoodID:'002',ImgUrl:'./images/1003.png',Price:50},
        {GoodID:'003',ImgUrl:'./images/4003.png',Price:50}
    ]
},{
    title:'3C',
    rows:[
        {GoodID:'001',ImgUrl:'./images/1002.png',Price:50},
        {GoodID:'002',ImgUrl:'./images/1003.png',Price:50},
        {GoodID:'003',ImgUrl:'./images/4003.png',Price:50}
    ]
}]
createGoods('#goods-box',data);
