function addTooltip(token)
{
    token.qtip({
        content: token.find('.tooltip'),
        hide: {
            fixed: true,
            delay: 200
        },
        show: {
            delay: 200,
        },
        style: {
            classes: "qtip-bootstrap"
        },
        position: {
            my: 'bottom center',
            at: 'top center',
            viewport: $(window),
            adjust: {
                    method: 'shift flip'
            }
        }
    });

}

var ready;
ready = function() {
    $('div.token.word').each(function () {
        addTooltip($(this));
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);