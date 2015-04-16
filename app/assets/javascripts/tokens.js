function addTokenTooltip(token)
{
    token.qtip({
        content: token.find('.tooltip'),
        show: {
            //event: 'click',
            solo: true,
            delay: 300,
            effect: function() {
                $(this).fadeTo(200, 1);
            }
        },
        hide: {
            when: {
                event:'mouseout unfocus'
            },
            fixed: true,
            delay: 500,
            effect: function() {
                $(this).fadeTo(100, 0);
            }
        },
        //hide: {
        //    fixed: true,
        //    delay: 100,
        //},
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

function addTokenTooltips()
{
    $('div.token.word').each(function () {
        addTokenTooltip($(this));
    });
}

var ready;
ready = function() {
    addTokenTooltips();
};

$(document).ready(ready);
$(document).on('page:load', ready);