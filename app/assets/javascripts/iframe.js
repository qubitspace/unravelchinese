var _ytPlayer = null;
var _previousSection = null;
var _currentSection = null;
var _selectedSection = null;
var _timerCheckPlaybackTime = null;
var _iframeFloatable = true;

var _playerReady = false;
var _tooltipState = "closed";

var _youTubeAPIReady = false;
var _pageReady = false;

//this function is called by the API
function onYouTubeIframeAPIReady() {
  loadYouTubePlayer();
  _youTubeAPIReady = true;
}

var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

function loadYouTubePlayer() {
  if (_ytPlayer == null && _youTubeAPIReady && _pageReady) {
    var videoId = $('#ytplayer').attr('video-id');

    _ytPlayer = new YT.Player('ytplayer', {
      videoId: videoId,
      playerVars: { rel: 0, controls: 2, showinfo: 0, modestbranding: 1, disablekb: 0 },
      events: {
        onReady: onPlayerReady,
        onStateChange: onPlayerStateChange
      }
    });
    addStartFromSectionAction();
  }
}
var _playTime = Date.now();

// "closed", "pausing", "open"
function onOpenTooltip() {
  if( _playerReady ) {
    var playerState = _ytPlayer.getPlayerState();
    var timeSincePlay = Date.now() - _playTime;
    var videoPlaying = playerState == 3 || playerState == 1 || timeSincePlay < 200;
    // Tooltip closed and player is stoped then pause it and set state to paused
    if( videoPlaying ) {
      _tooltipState = "pausing";
      _ytPlayer.pauseVideo();
    }
    else if ( _tooltipState == "pausing" ) {
      _tooltipState = "pausing";
    }
    else {
      _tooltipState = "open"
    }
  }
}

function onCloseTooltip() {
  if( _playerReady ) {
    var playerState = _ytPlayer.getPlayerState();
    var videoPlaying = playerState == 3 || playerState == 1;
    if( _tooltipState == "pausing" ) {
      _ytPlayer.playVideo();
      _playTime = Date.now();
    }
    _tooltipState = "closed";
  }
}

function playPause() {
  if( _playerReady ) {
    var playerState = _ytPlayer.getPlayerState();
    var videoPlaying = playerState == 3 || playerState == 1;
    if (videoPlaying) {
      pauseVideo();
    }
    else {
      playVideo();
    }
  }
}

function goToNextSection() {
  if( _playerReady ) {
    if (_selectedSection) {
      nextSection = _selectedSection.next();
      // Not a section, reached the end
      if (nextSection.hasClass('section')) {
        _selectedSection.removeClass('active-section');
        _selectedSection = nextSection;
        _selectedSection.addClass('active-section');
      }
    }
    else {
      _selectedSection = $('.section').first();
    }
  }
  startTime = parseFloat(_selectedSection.attr('start-time'));
  _ytPlayer.seekTo(parseFloat(startTime));
}

function goToPreviousSection() {
  if( _playerReady ) {
    if (_selectedSection) {
      prevSection = _selectedSection.prev();
      // Not a section, reached the end
      if (prevSection.hasClass('section')) {
        _selectedSection.removeClass('active-section');
        _selectedSection = prevSection;
        _selectedSection.addClass('active-section');
      }
    }
    else {
      _selectedSection = $('.section').first();
    }
    startTime = parseFloat(_selectedSection.attr('start-time'));
    _ytPlayer.seekTo(parseFloat(startTime));
  }
}

function replaySection() {
  if( _playerReady ) {
    if (_selectedSection) {
      startTime = parseFloat(_selectedSection.attr('start-time'));
      _ytPlayer.seekTo(parseFloat(startTime));
    }
    playVideo();
  }
}

function playVideo() {
  if( _playerReady ) {
    _playing = true;
    _ytPlayer.playVideo();
  }
}

function pauseVideo() {
  if( _playerReady ) {
    _playing = false;
    _ytPlayer.pauseVideo();
  }
}

function onPlayerReady() {
  _playerReady = true;
}

function onPlayerStateChange(event) {
  switch(event.data) {
    case YT.PlayerState.ENDED:
      clearInterval(_timerCheckPlaybackTime);
      break;
    case YT.PlayerState.PLAYING:
      resetCurrentSentence();
      _timerCheckPlaybackTime = setInterval(markCurrentSentence, 250);
      break;
    case YT.PlayerState.PAUSED:
      clearInterval(_timerCheckPlaybackTime);
      break;
    case YT.PlayerState.BUFFERING:
      clearInterval(_timerCheckPlaybackTime);
      break;
    case YT.PlayerState.CUED:
      clearInterval(_timerCheckPlaybackTime);
      break;
  }
}

function unbindKeys() {
  $(document).unbind("keypress");
  _currentSection = $('.section').first();
}

function bindKeys() {
  $(document).keypress(function( event ) {
    if( _playerReady ) {
      var currentTime = _ytPlayer.getCurrentTime();
      if(!_currentSection) {
        _currentSection = $('.section').first();
      }

      if (event.which == 115) {
        if (_currentSection.hasClass('section')) {
          sectionId = _currentSection.attr('section-id');
          $.ajax({
            url: "/sections/" + sectionId + "/set_start_time",
            type: "POST",
            data: { start_time: currentTime }
          });
          previousSection = _currentSection;
          _currentSection = _currentSection.next();
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
          previousSection = _currentSection;
          _currentSection = _currentSection.next();
        }
      }
    }
  });
}

function startRecordingTimes(sectionId) {
  if( _playerReady ) {
    bindKeys();
    _ytPlayer.seekTo(0);
    _ytPlayer.playVideo();
  }
}

function stopRecordingTimes(sectionId) {
  if( _playerReady ) {
    unbindKeys();
    _ytPlayer.seekTo(0);
    _ytPlayer.stopVideo();
  }
}

function startFromSection(sectionId, startTime) {
  if( _playerReady ) {
    if (_selectedSection) {
      _selectedSection.removeClass('active-section');
    }
    playedSection = $(".section[section-id='" + sectionId + "']");
    playedSection.addClass('active-section');
    _selectedSection = playedSection;

    _ytPlayer.seekTo(parseFloat(startTime));
    playVideo();
  }
}

function resetCurrentSentence() {
  if ( _playerReady && _selectedSection) {
    var playbackTime = _ytPlayer.getCurrentTime();
    sentenceStartTime = parseFloat(_selectedSection.attr('start-time'));
    if (playbackTime < sentenceStartTime) {
      _selectedSection.removeClass('active-section');

      _selectedSection = null;
      previousSection = null;
      _currentSection = null;
    }
  }
  else {
    _selectedSection = null;
    previousSection = null;
    _currentSection = null;
  }
}

function markCurrentSentence() {
  if ( _playerReady ) {
    var playbackTime = _ytPlayer.getCurrentTime();

    var keepLooking = true;
    if (!_selectedSection) {
      _selectedSection = $('.section').first();
    }

    while (keepLooking) {
      nextSection = _selectedSection.next();
      // Not a section, reached the end
      if (!_selectedSection.hasClass('section')) {
        _selectedSection = $('.section').first();
        return false;
      }

      nextStartTime = parseFloat(nextSection.attr('start-time'));
      sentenceStartTime = parseFloat(_selectedSection.attr('start-time'));
      sentenceEndTime = parseFloat(_selectedSection.attr('end-time'));

      // Sentence hasn't started yet, keep waiting
      if (sentenceStartTime >= playbackTime) {
        return false;
      }


      // If were after the current section start time, behind the end time
      // and before the next sections start time. Mark this sentence.
      if (playbackTime >= sentenceStartTime
            && (isNaN(sentenceEndTime) || playbackTime < sentenceEndTime)
            && (isNaN(nextStartTime) || playbackTime < nextStartTime)) {
        keepLooking = false;
        $(_selectedSection).addClass('active-section');
        return false;
      }
      else {
        $(_selectedSection).removeClass('active-section');
      }

      _selectedSection = nextSection;
    }
  }
}



function toggleFloatingIframe() {
  if (_iframeFloatable) { // If floatable
    // Set not Floatable
    pinVideo();
    _iframeFloatable = false;
  }
  else { // Else not floatable
    _iframeFloatable = true;
    checkScrollLocation();
  }

}

function checkScrollLocation() {
  if ($('#iframe-container') && $('#iframe-container').offset()) {
    var topOfDiv = $("#iframe-container").offset().top; //gets offset of header
    var height = $("#iframe-container").outerHeight(); //gets height of header

    if($(window).scrollTop() > (topOfDiv + height)) {
      floatVideo();
      //showControls();
    }
    else {
      pinVideo();
      //hideControls();
    }


    var controls = $("#iframe-controls");
    if($(window).scrollTop() < 100) {
      controls.css({
        position: 'absolute',
        top: 100
      });
    }
    else {
       controls.css({
        position: 'fixed',
        top: 0
      });
     }
  }
}

function addScrollCheck() {
  $(window).scroll(function() {
    checkScrollLocation();
  });
}

function checkControlPosition() {

}

// function hideControls() {
//   $("#iframe-controls").hide();
// }

// function showControls() {
//   $("#iframe-controls").show();
// }


function pinVideo() {
  $("#iframe-wrapper").removeClass("iframe-float-right");
  $("#iframe-wrapper").addClass("iframe-full-size");
  $("#left-iframe-wrapper").hide();

  setPinnedVideoSize();
}

function floatVideo() {
  if (_iframeFloatable)
  {
    $("#iframe-wrapper").removeClass("iframe-full-size");
    $("#iframe-wrapper").addClass("iframe-float-right");
    $("#left-iframe-wrapper").show();
    setFloatVideoSize();
  }
}

function bindWindowResizeFunction() {
  $( window ).resize(function() {
    if ($("#iframe-wrapper").hasClass("iframe-full-size")) {
      setPinnedVideoSize();
    }
    else {
      setFloatVideoSize();
    }
  });
}

function setPinnedVideoSize() {
  var width = $('#iframe-wrapper').width();
  $("#iframe-wrapper").width(width);
  $("#iframe-wrapper").height(width*0.5625);
}

function setFloatVideoSize() {
  var left = $('.left-column').first();
  var main = $('.main-column').first();
  var width = $(window).width() - (left.outerWidth() + main.outerWidth());

  $("#iframe-wrapper").width(width);
  $("#iframe-wrapper").height(width*0.5625);
}

function addActionToSection(section) {
  var sectionId = section.attr('section-id');
  var startTime = section.attr('start-time');
  var link = section.find('.play-button a').first();
  link.click(function() {
    startFromSection(sectionId, startTime);
  });
  link.show();
}

function addStartFromSectionAction() {
  $('.section.inline').each(function () {
      addActionToSection($(this));
  });
}

$(window).load(function(){
  _pageReady = true;
  addScrollCheck();
  bindWindowResizeFunction();
  loadYouTubePlayer();
});

