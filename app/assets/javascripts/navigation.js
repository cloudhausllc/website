$(function () {
    // console.log($('[data-action="navigate"]'));
    $('[data-action="navigate"]').click(function (event) {
        event.preventDefault();
        Turbolinks.visit($(this).attr('data-url'));
    })
})