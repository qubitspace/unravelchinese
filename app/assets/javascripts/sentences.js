// Change these to be adding/removing classes instead od changing css!

// function addCloseDefinitionTooltipActions() {
//     $('.close_translation_tooltip').click(function() {
//         $(this).parent().prev().css('display', 'inline');
//         $(this).parent().prev().css('border', '0px');
//         $(this).parent().hide();
//     });
// }

// function addToggleTranslationActions() {
//     $('.toggle_translations').click(function() {
//         if ( $(this).parent().next().css("display") == "none" ) {
//             $(this).parent().css('display', 'block');
//             $(this).parent().addClass('selected');
//         } else {
//             $(this).parent().css('display', 'inline');
//             $(this).parent().removeClass('selected');
//         }
//         $(this).parent().next().toggle();
//     });
// }

function addSentenceTooltip(toggleIcon) {

  toggleIcon.qtip({
    content: toggleIcon.find('.sentence-tooltip'),
    show: {
      event: 'mouseover',
      solo: true,
      delay: 100,
      effect: function() {
        $(this).fadeTo(200, 1);
        pauseVideoIfPlaying();
      }
    },
    hide: {
      event: 'mouseout',
      fixed: true,
      delay: 300,
      effect: function() {
        playVideoIfPlaying();
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


function addSentenceTooltips()
{
  $('.sentence.inline .toggle-translations').each(function () {
    addSentenceTooltip($(this));
  });
}

var ready;
ready = function() {
  addSentenceTooltips();
};

$(document).ready(ready);
$(document).on('page:load', ready);


