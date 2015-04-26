function addTranslationTooltip(translations)
{
    translations.qtip({
        content: translations.find('.translations'),
        show: {
            event: 'click',
            solo: true,
            effect: function() {
                $(this).fadeTo(200, 1);
            }
        },
        hide: {
            event: 'unfocus',
            target: $('.close'),
            fixed: true,
            effect: function() {
                $(this).fadeTo(100, 0);
            }
        },
        style: {
            classes: "qtip-bootstrap"
        },
        position: {
            my: 'top center',
            at: 'bottom center',
            viewport: $(window),
            adjust: {
                method: 'shift flip'
            }
        }
    });

}

function addTranslationTooltips()
{
    $('.toggle_translations').each(function () {
        addTranslationTooltip($(this));
    });
}

function addCloseDefinitionTooltipActions()
{
    $('.close_translation_tooltip').click(function() {
      $(this).closest('div.qtip').hide();
    });
}

var ready;
ready = function() {
    addTranslationTooltips();
    addCloseDefinitionTooltipActions();
};

$(document).ready(ready);
$(document).on('page:load', ready);


