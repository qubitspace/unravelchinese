function addWordTooltip(top) {
  var word = top.parent();
  top.qtip({
    content: word.find('.tooltip'),
    show: {
      event: 'mouseover',
      solo: true,
      delay: 100,
      effect: function() {
        $(this).fadeTo(200, 1);
        //pauseVideo();
      }
    },
    hide: {
      event: 'mouseout',
      fixed: true,
      delay: 200,
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
  $('.word.inline.chinese .top').each(function () {
    addWordTooltip($(this));
  });
}

function addLearningMouseover(word) {
  // word.mouseover(function() {
  //   $(this).find(".bottom").css('visibility', 'visible');
  // });
  // word.mouseout(function() {
  //   $(this).find(".bottom").css('visibility', 'hidden');
  // });
}

// function addLearningMouseovers() {
//   $('.word.learning').each(function () {
//     addLearningMouseover($(this));
//   });
// }

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
  //addLearningMouseovers();
  addCloseWordTooltipActions();
};

$(document).ready(ready);
$(document).on('page:load', ready);
