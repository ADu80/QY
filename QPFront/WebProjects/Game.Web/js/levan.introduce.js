(function ($) {
    var headerClass = ".header",
        webpathClass = ".webpath",
        contentClass = ".content",
        footerClass = ".footer";
    var windowHeight = $(window).height();
    var headerHeight = $(headerClass).height() + parseFloat($(headerClass).css('marginTop')) + parseFloat($(headerClass).css('marginBottom')) + parseFloat($(headerClass).css('paddingTop')) + parseFloat($(headerClass).css('paddingBottom')),
        webpathHeight = $(webpathClass).height() + parseFloat($(webpathClass).css('marginTop')) + parseFloat($(webpathClass).css('marginBottom')) + parseFloat($(webpathClass).css('paddingTop')) + parseFloat($(webpathClass).css('paddingBottom')),
        footerHeight = $(footerClass).height() + parseFloat($(footerClass).css('marginTop')) + parseFloat($(footerClass).css('marginBottom')) + parseFloat($(footerClass).css('paddingTop')) + parseFloat($(footerClass).css('paddingBottom')),
        contentMarginPadding = parseFloat($(contentClass).css('marginTop')) + parseFloat($(contentClass).css('marginBottom')) + parseFloat($(contentClass).css('paddingTop')) + parseFloat($(contentClass).css('paddingBottom')),
        contentHeight = windowHeight - headerHeight - webpathHeight - footerHeight - contentMarginPadding;
    if (parseFloat($(contentClass).css('height')) < contentHeight) {
        $(contentClass).css({ height: contentHeight });
    }
})(jQuery);