import SlideTab from '../../commons/basic/tab';
import good from './gooddetail.mock';

var onTabSlided = (e) => {

}

var initData = () => {

}


var initAction = () => {
    new SlideTab('tab-1', onTabSlided);
}

export var init = () => {
    initData();
    initAction();
}
