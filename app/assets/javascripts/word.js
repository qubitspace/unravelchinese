function addWordTooltip(word) {
    word.qtip({
        content: word.find('.tooltip'),
        show: {
            event: 'click',
            solo: true,
            effect: function() {
                $(this).fadeTo(200, 1);
            }
        },
        hide: {
            event: 'unfocus',
            fixed: true
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

function addWordTooltips()
{
    $('.word').each(function () {
        addWordTooltip($(this));
    });
}

function addLearningMouseover(word) {
    word.mouseover(function() {
        $(this).find(".bottom").css('color', '#666');
    });
    word.mouseout(function() {
        $(this).find(".bottom").css('color', '#FFFFFF');
    });
}

function addLearningMouseovers() {
    $('.word.learning').each(function () {
        addLearningMouseover($(this));
    });
}

function addCloseWordTooltipActions() {
    $('.close_tooltip').click(function() {
        $(this).closest('div.qtip').hide();
    });
}

var ready;
ready = function() {
    addWordTooltips();
    addLearningMouseovers();
    addCloseWordTooltipActions();
};

$(document).ready(ready);
$(document).on('page:load', ready);
