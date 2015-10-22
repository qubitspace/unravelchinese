var ytPlayer = null;

var previousSection = null;
var currentSection = null;
var selectedSection = null;

var timerCheckPlaybackTime = null;

var iframeFloatable = true;
var videoPlayerPresent = false;

// This function will be called when the API is fully loaded
// I'm also passing this in as the onReady function.
function onYouTubePlayerAPIReady() {
  getYTPlayer();
}

function getYTPlayer() {

  if (!ytPlayer || !ytPlayer.f || !ytPlayer.f.id == 'ytplayer') {
    ytPlayer = new YT.Player('ytplayer', {
      events: {
        'onReady': onYouTubePlayerAPIReady,
        'onStateChange': onPlayerStateChange
      }
    });
  }

  return ytPlayer;
}

function onPlayerReady() {
  getYTPlayer();
}

function pauseVideo() {
  player = getYTPlayer();
  if(player != null) {
    player.pauseVideo();
  }
}

function playVideo() {
  player = getYTPlayer();
  if(player != null) {
    player.playVideo();
  }
}

function bindKeys() {
  $(document).keypress(function( event ) {
    player = getYTPlayer();
    if(player != null) {
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
    }
  });
}

function startFromSection(sectionId, startTime) {
  player = getYTPlayer();
  if(player != null) {
    player.seekTo(startTime);

    if (selectedSection) {
      selectedSection.removeClass('active-section');
    }
    playedSection = $(".section[section-id='" + sectionId + "']");
    playedSection.addClass('active-section');
    selectedSection = playedSection;

    player.playVideo();
  }
}


function onPlayerStateChange(event) {
  switch(event.data) {
    case YT.PlayerState.ENDED:
      clearInterval(timerCheckPlaybackTime);
      break;
    case YT.PlayerState.PLAYING:
      resetCurrentSentence();
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

function resetCurrentSentence() {
  selectedSection.removeClass('active-section');
  selectedSection = null;
  previousSection = null;
  currentSection = null;
}

function markCurrentSentence() {
  player = getYTPlayer();
  if(player != null) {
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


      // If were after the current section start time, behind the end time
      // and before the next sections start time. Mark this sentence.
      if (playbackTime >= sentenceStartTime
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

function checkScrollLocation() {
  if ($('#iframe-container') && $('#iframe-container').offset()) {
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

function addScrollCheck() {
  $(window).scroll(function() {
    checkScrollLocation();
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
  if (iframeFloatable)
  {
    $("#ytplayer").removeClass("iframe-full-size");
    $("#ytplayer").addClass("iframe-float-right");
    $("#left-iframe-wrapper").show();
    setFloatVideoSize();
  }
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
  addScrollCheck();
  bindKeys();
  bindWindowResizeFunction();
});
