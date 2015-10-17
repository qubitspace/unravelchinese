// Change these to be adding/removing classes instead od changing css!

function addCloseDefinitionTooltipActions() {
    $('.close_translation_tooltip').click(function() {
        $(this).parent().prev().css('display', 'inline');
        $(this).parent().prev().css('border', '0px');
        $(this).parent().hide();
    });
}

function addToggleTranslationActions() {
    $('.toggle_translations').click(function() {
        if ( $(this).parent().next().css("display") == "none" ) {
            $(this).parent().css('display', 'block');
            $(this).parent().addClass('selected');
        } else {
            $(this).parent().css('display', 'inline');
            $(this).parent().removeClass('selected');
        }
        $(this).parent().next().toggle();
    });
}

var ready;
ready = function() {
    addToggleTranslationActions();
    addCloseDefinitionTooltipActions();
};

$(document).ready(ready);
$(document).on('page:load', ready);


