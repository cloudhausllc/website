$(function () {
    $('[data-action="navigate"]').click(function (event) {
        event.preventDefault();
        console.log('hit');
        Turbolinks.visit($(this).attr('data-url'));
    })
})