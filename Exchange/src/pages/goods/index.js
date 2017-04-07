// var $ = jQuery = require('jquery');

import './goods.css';
import '../../commons/common.css';
import fit from '../../commons/common';
import createGoods from './goods';

fit();


var data = [{
    title: 'Hot',
    rows: [
        { GoodID: '001', ImgUrl: './images/1002.png', Price: 50 },
        { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 },
        { GoodID: '003', ImgUrl: './images/4003.png', Price: 50 }
    ]
}, {
    title: '3C',
    rows: [
        { GoodID: '001', ImgUrl: './images/1002.png', Price: 50 },
        { GoodID: '002', ImgUrl: './images/1003.png', Price: 50 },
        { GoodID: '003', ImgUrl: './images/4003.png', Price: 50 }
    ]
}];

createGoods('#good-list', data);
