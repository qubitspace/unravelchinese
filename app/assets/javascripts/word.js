function addWordTooltip(top) {
  var word = top.parent();
  top.qtip({
    content: word.find('.word-tooltip'),
    show: {
      event: 'mouseover',
      solo: true,
      delay: 100,
      effect: function() {
        $(this).fadeTo(0, 1);
        //onOpenTooltip();
      }
    },
    hide: {
      event: 'mouseout',
      fixed: true,
      delay: 150,
      effect: function() {
        //onCloseTooltip();
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
  $('.word.inline.chinese .top').each(function () {
    addWordTooltip($(this));
  });
}


var ready;
ready = function() {
  addWordTooltips();

  if (window.location.pathname.match(/\/articles\/\d+$/)) {
    $(document).keyup(function(e) {
      var keyCode = (window.event) ? e.which : e.keyCode;

      if (keyCode == 68) { // 'd'
        goToPreviousSection();
      }
      else if (keyCode == 70) { // 'f'
        goToNextSection();
      }
      else if (keyCode == 83) { // 's'
        playPause();
      }
      else if (keyCode == 82) { // 'r'
        replaySection();
      }
    });
  }
};

$(document).ready(ready);
$(document).on('page:load', ready);
