function scrollTo(selectorOrElement) {
    var $selector = $(selectorOrElement);
    
    $('html, body').animate({
        scrollTop: $selector.offset().top
    }, 200);
}