import FastClick from 'fastclick';
import '../../commons/vendor/iconfont/iconfont.css';
import '../../commons/basic/comm.css';
import './goods.css';

import { fit } from '../../commons/basic/fit';
import { initData, initAction } from './goods';

$(function(e) {
    FastClick.attach(document.body);
    fit();
    initAction();
    initData();
});
