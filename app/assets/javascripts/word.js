function addWordTooltip(top) {
  var word = top.parent();
  top.qtip({
    content: word.find('.word-tooltip'),
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

function addWordTooltips()
{
  $('.word.inline.chinese .top').each(function () {
    addWordTooltip($(this));
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
};

$(document).ready(ready);
$(document).on('page:load', ready);
