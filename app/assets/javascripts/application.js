// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require_tree .
//= require jquery_nested_form

var iframeFloatable = true;
function pauseVideo() {
  player.pauseVideo();
  //document.getElementById('iframe').contentWindow.postMessage(
  //  '{"event":"command","func":"pauseVideo","args":""}', '*'
  //);
}

function playVideo() {
  player.playVideo();
  //document.getElementById('iframe').contentWindow.postMessage(
  //  '{"event":"command","func":"playVideo","args":""}', '*'
  //);
}

function startFromSection(sectionId, startTime) {
  if (player) {
    player.seekTo(startTime);
    player.playVideo();
    $(selectedSection).removeClass('active-section');
    selectedSection = $(".section[section-id='" + sectionId + "']");
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

var player;
var timerCheckPlaybackTime;
var previousSection;

function getPlaybackTime() {
  if (player) {
    return parseFloat(player.getCurrentTime());
  }
  return 0.0;
}

/*
  OnPlaying loop
  If there is sentences left to check
  if were past that sentence, move on until were not past it
  if we hit the end then stop
  if we get to a sentence that is current playing (and were still behind the next sentence) then set it active

  whenever there is a state change besides play/pause, reset everything and find the current sentences
    then turn on the replay function.


  always keep track of ActiveSentence to clear the last one

*/

var selectedSection;

// TODO: add a way to unmark a section if it finished.
function markCurrentSentence() {
  if (player) {
    playbackTime = getPlaybackTime();

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

function onYouTubeIframeAPIReady() {
  player = new YT.Player( 'iframe', {
     events: {
      'onReady': onPlayerReady,
      'onPlaybackQualityChange': onPlayerPlaybackQualityChange,
      'onStateChange': onPlayerStateChange,
      'onError': onPlayerError }
  });
}

var currentSection = null;

function onPlayerReady() {
  if (player) {
    $(document).keypress(function( event ) {
      var currentTime = getPlaybackTime();
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
}

function playSentence(sentenceId) {
  sentence = $(".sentence[sentence-id=#{sentenceId}]")
  startTime = sentence.parent().attr('start-time');
}

function onPlayerPlaybackQualityChange() {
}

function onPlayerError() {
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


function record(data){
    // Do what you want with your data
  var p = document.createElement("p");
  p.appendChild(document.createTextNode(data));
  document.body.appendChild(p);
}


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
  $("#iframe").removeClass("iframe-float-right");
  $("#iframe").addClass("iframe-full-size");
  $("#left-iframe-wrapper").hide();
}

function floatVideo() {
  $("#iframe").removeClass("iframe-full-size");
  $("#iframe").addClass("iframe-float-right");
  $("#left-iframe-wrapper").show();
}


var ready;
ready = function() {
  checkScrollLocation();
};

$(document).ready(ready);
$(document).on('page:load', ready);



