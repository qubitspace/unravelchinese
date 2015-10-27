var _ytPlayer = null;
var _previousSection = null;
var _currentSection = null;
var _selectedSection = null;
var _timerCheckPlaybackTime = null;
var _iframeFloatable = true;

var _playerReady = false;

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
      events: {
        onReady: onPlayerReady,
        onStateChange: onPlayerStateChange
      }
    });
    addStartFromSectionAction();
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

function startFromSection(sectionId, startTime) {
  if( _playerReady ) {
    if (_selectedSection) {
      _selectedSection.removeClass('active-section');
    }
    playedSection = $(".section[section-id='" + sectionId + "']");
    playedSection.addClass('active-section');
    _selectedSection = playedSection;

    _ytPlayer.seekTo(parseFloat(startTime));
    _ytPlayer.playVideo();
  }
}

function resetCurrentSentence() {
  if ( _playerReady ) {
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
  if (_iframeFloatable)
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
  var width = $('#iframe-wrapper').width();
  $("#ytplayer").width(width);
  $("#ytplayer").height(width*0.5625);
}

function setFloatVideoSize() {
  var left = $('.left-column').first();
  var main = $('.main-column').first();
  var width = $(window).width() - (left.outerWidth() + main.outerWidth());

  $("#ytplayer").width(width);
  $("#ytplayer").height(width*0.5625);
}

function addActionToSection(section) {
  var sectionId = section.attr('section-id');
  var startTime = section.attr('start-time');
  section.find('.play-button a').first().click(function() {
    startFromSection(sectionId, startTime);
  });
}

function addStartFromSectionAction() {
    $('.section.inline').each(function () {
        addActionToSection($(this));
    });
}

$(window).load(function(){
  _pageReady = true;
  addScrollCheck();
  bindKeys();
  bindWindowResizeFunction();
  loadYouTubePlayer();
});

