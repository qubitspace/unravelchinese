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
    $('.word_wrapper.word').each(function () {
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
    $('.word_wrapper.word.learning').each(function () {
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
    addExpandRelatedWordActions();
};

$(document).ready(ready);
$(document).on('page:load', ready);

function addExpandRelatedWordActions() {
  $('.expand_related_word_button').click(function() {
    e = $(this).parent().parent();
    if(e.css('max-height') == '1000px') {
      e.css('max-height', '60px');
    }
    else {
      e.css('max-height', '1000px');
    }
  });
}
