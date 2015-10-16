function addWordTooltip(word) {
    word.qtip({
        content: word.find('.tooltip'),
        show: {
            event: 'click',
            solo: true,
            effect: function() {
                $(this).fadeTo(200, 1);
                //pauseVideo();
            }
        },
        hide: {
            event: 'unfocus',
            fixed: true,
            effect: function() {
                //playVideo();
            }
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
    $('.word.chinese').each(function () {
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

function closeTooltip() {
    $('div.qtip:visible').hide();
    //playVideo();
}

function addCloseWordTooltipActions() {
    $('.close_tooltip').click(function() {
        closeTooltip();
    });
}

$(document).keyup(function(e) {
    if (e.keyCode == 27) {
        closeTooltip();
    }
    else if (e.keyCode == 37) {
        closeTooltip();
    }
    else if (e.keyCode == 39) {
        closeTooltip();
    }
});

var ready;
ready = function() {
    addWordTooltips();
    addLearningMouseovers();
    addCloseWordTooltipActions();
};

$(document).ready(ready);
$(document).on('page:load', ready);
