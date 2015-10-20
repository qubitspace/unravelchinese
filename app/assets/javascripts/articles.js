var player;
var currentSection = null;

var selectedSection;
var timerCheckPlaybackTime;
var previousSection;

var iframeFloatable = true;

// This function will be called when the API is fully loaded
function onYouTubePlayerAPIReady() { YTQueue(true);  }

function onPlayerReady() {
}

// Define YTQueue function.
var YTQueue = (function() {
    var onReady_funcs = [], api_isReady = false;
    /* @param func function     Function to execute on ready
     * @param func Boolean      If true, all qeued functions are executed
     * @param b_before Boolean  If true, the func will added to the first
                                 position in the queue*/
    return function(func, b_before) {
        if (func === true) {
            api_isReady = true;
            while (onReady_funcs.length) {
                // Removes the first func from the array, and execute func
                onReady_funcs.shift()();
            }
        } else if (typeof func == "function") {
            if (api_isReady) func();
            else onReady_funcs[b_before?"unshift":"push"](func);
        }
    }
})();

function bindKeys() {

  $(document).keypress(function( event ) {
    var currentTime = player.getCurrentTime();
    if(!currentSection) {
      currentSection = $('.section').first();
    }

    if (event.which == 115) {
      if (currentSection.hasClass('section')) {
        sectionId = currentSection.attr('section-id');
        $.ajax({
          url: "/sections/" + sectionId + "/set_start_time",
          type: "POST",
          data: { start_time: currentTime }
        });
        previousSection = currentSection;
        currentSection = currentSection.next();
      }
    }
    else if (event.which == 101) {
      if (previousSection.hasClass('section')) {
        sectionId = previousSection.attr('section-id');
        $.ajax({
          url: "/sections/" + sectionId + "/set_end_time",
          type: "POST",
          data: { end_time: currentTime }
        });
        previousSection = currentSection;
        currentSection = currentSection.next();
      }
    }
  });
}

function startFromSection(sectionId, startTime) {
  if (player) {
    try {
      playedSection = $(".section[section-id='" + sectionId + "']");
      playedSection.addClass('active-section');
      player.seekTo(startTime);
      player.playVideo();
      selectedSection.removeClass('active-section');
      selectedSection = playedSection;

    }
    catch(err) {
        // Handle error(s) here
    }
  }
}


function onPlayerStateChange(event) {
  switch(event.data) {
    case YT.PlayerState.ENDED:
      clearInterval(timerCheckPlaybackTime);
      break;
    case YT.PlayerState.PLAYING:
      timerCheckPlaybackTime = setInterval(markCurrentSentence, 250);
      break;
    case YT.PlayerState.PAUSED:
      clearInterval(timerCheckPlaybackTime);
      break;
    case YT.PlayerState.BUFFERING:
      clearInterval(timerCheckPlaybackTime);
      break;
    case YT.PlayerState.CUED:
      clearInterval(timerCheckPlaybackTime);
      break;
  }
}


function markCurrentSentence() {
  if (player) {
    playbackTime = player.getCurrentTime();

    var keepLooking = true;
    if (!selectedSection) {
      selectedSection = $('.section').first();
    }

    while (keepLooking) {
      nextSection = selectedSection.next();
      // Not a section, reached the end
      if (!selectedSection.hasClass('section')) {
        selectedSection = $('.section').first();
        return false;
      }

      nextStartTime = parseFloat(nextSection.attr('start-time'));
      sentenceStartTime = parseFloat(selectedSection.attr('start-time'));
      sentenceEndTime = parseFloat(selectedSection.attr('end-time'));

      // Sentence hasn't started yet, keep waiting
      if (sentenceStartTime > playbackTime) {
        return false;
      }

      if (nextSection)

      // If were after the current section start time, behind the end time
      // and before the next sections start time. Mark this sentence.
      if (playbackTime > sentenceStartTime
            && (isNaN(sentenceEndTime) || playbackTime < sentenceEndTime)
            && (isNaN(nextStartTime) || playbackTime < nextStartTime)) {
        keepLooking = false;
        $(selectedSection).addClass('active-section');
        return false;
      }
      else {
         $(selectedSection).removeClass('active-section');
      }

      selectedSection = nextSection;
    }
  }
  else {
    alert('no player');
  }
}



function toggleFloatingIframe() {
  if (iframeFloatable) { // If floatable
    // Set not Floatable
    pinVideo();
    iframeFloatable = false;
  }
  else { // Else not floatable
    iframeFloatable = true;
    checkScrollLocation();
  }

}

var ready = function() {
  bindKeys();
  YTQueue(function(){
    player = new YT.Player('ytplayer', {
      events: {
        'onReady': onPlayerReady,
        'onStateChange': onPlayerStateChange
      }
    });
  });
};


function checkScrollLocation() {
  $(window).scroll(function() {
    if (player) {
      if (iframeFloatable && $('#iframe-container') && $('#iframe-container').offset()) {
        var topOfDiv = $("#iframe-container").offset().top; //gets offset of header
        var height = $("#iframe-container").outerHeight(); //gets height of header

        if($(window).scrollTop() > (topOfDiv + height)) {
          floatVideo();
          showControls();
        }
        else {
          pinVideo();
          hideControls();
        }
      }
    }
  });
}


function hideControls() {
  $("#iframe-controls").hide();
}

function showControls() {
  $("#iframe-controls").show();
}


function pinVideo() {
  $("#ytplayer").removeClass("iframe-float-right");
  $("#ytplayer").addClass("iframe-full-size");
  $("#left-iframe-wrapper").hide();

  setPinnedVideoSize();
}

function floatVideo() {
  $("#ytplayer").removeClass("iframe-full-size");
  $("#ytplayer").addClass("iframe-float-right");
  $("#left-iframe-wrapper").show();

  setFloatVideoSize();
}

function bindWindowResizeFunction() {
  $( window ).resize(function() {
    if ($("#ytplayer").hasClass("iframe-full-size")) {
      setPinnedVideoSize();
    }
    else {
      setFloatVideoSize();
    }
  });
}

function setPinnedVideoSize() {
  width = $('#iframe-wrapper').width();
  $("#ytplayer").width(width);
  $("#ytplayer").height(width*0.5625);
}

function setFloatVideoSize() {
  left = $('.left-column').first();
  main = $('.main-column').first();
  width = $(window).width() - (left.outerWidth() + main.outerWidth());

  $("#ytplayer").width(width);
  $("#ytplayer").height(width*0.5625);
}

$(function() {
  checkScrollLocation();
  bindKeys();
  bindWindowResizeFunction();
  YTQueue(function(){
    player = new YT.Player('ytplayer', {
      events: {
        'onReady': onPlayerReady,
        'onStateChange': onPlayerStateChange
      }
    });
  });
});
