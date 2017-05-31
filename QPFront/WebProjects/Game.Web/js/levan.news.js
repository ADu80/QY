(function ($) {
    var headerClass = ".header",
        contentClass = ".content",
        footerClass = ".footer";
    var windowHeight = $(window).height();
    var headerHeight = $(headerClass).height() + parseFloat($(headerClass).css('marginTop')) + parseFloat($(headerClass).css('marginBottom')) + parseFloat($(headerClass).css('paddingTop')) + parseFloat($(headerClass).css('paddingBottom')) + parseFloat($(headerClass).css('borderTopWidth')) + parseFloat($(headerClass).css('borderBottomWidth')),
        footerHeight = $(footerClass).height() + parseFloat($(footerClass).css('marginTop')) + parseFloat($(footerClass).css('marginBottom')) + parseFloat($(footerClass).css('paddingTop')) + parseFloat($(footerClass).css('paddingBottom')) + parseFloat($(footerClass).css('borderTopWidth')) + parseFloat($(footerClass).css('borderBottomWidth')),
        contentMarginPadding = parseFloat($(contentClass).css('marginTop')) + parseFloat($(contentClass).css('marginBottom')) + parseFloat($(contentClass).css('paddingTop')) + parseFloat($(contentClass).css('paddingBottom')) + parseFloat($(contentClass).css('borderTopWidth')) + parseFloat($(contentClass).css('borderBottomWidth')),
        contentHeight = windowHeight - headerHeight - footerHeight - contentMarginPadding;
    if (parseFloat($(contentClass).css('height')) < contentHeight) {
        $(contentClass).css({ height: contentHeight });
        console.log(contentHeight);
        $('.news-body').css({ height: contentHeight - 80 });
    }
})(jQuery);