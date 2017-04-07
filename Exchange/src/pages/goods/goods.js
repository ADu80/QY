export default (id, data) => {
    var tmpl = `${data.map(d => `
        <section class="good-group">
            <h1>${d.title}</h1>
            <ul>
                ${d.rows.map(r=>`
                    <li>
                        <a class="good-item" href="./pay.html?id=${r.GoodID}">
                            <img src="${r.ImgUrl}"></img>
                            <dl class="good-info">
                            	<dt><p class="title">Apple MacBook Pro 13.3英寸笔记本电脑 深空灰色</p></dt>
                            	<dt><i class="price">${r.Price}</i><dt>
                            </dl>
                        </a>
                    </li>`
                ).join('')}
            </ul>
        </section>
    `).join('')}`;
    $(id).append(tmpl);
}
