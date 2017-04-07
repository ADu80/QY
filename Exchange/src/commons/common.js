export default () => {
    var win = $(window),
        winWidth = win.width(),
        fontSize = winWidth / 30;
    document.body.fontSize = fontSize > 12 ? fontSize : 12;
}
