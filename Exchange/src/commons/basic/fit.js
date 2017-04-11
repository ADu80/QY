export default function fit() {
    console.log($('html').css('fontSize'));
    var winWdith = $(window).width();
    if (winWdith < 640) {
        $('html').css('fontSize', 16);
    } else if (winWdith < 1000) {
        $('html').css('fontSize', 20);
    } else {
        $('html').css('fontSize', 30);
    }
}
