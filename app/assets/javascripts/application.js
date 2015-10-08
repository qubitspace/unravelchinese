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

function pauseVideo() {
  document.getElementById('iframe').contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
}
function playVideo() {
  document.getElementById('iframe').contentWindow.postMessage('{"event":"command","func":"playVideo","args":""}', '*');
}



var player;
var timerCheckPlaybackTime;
var previousSection;
var currentSection;

function checkPlaybackTime() {
  if (player) {
    //record('video player at ' + player.getCurrentTime());
  }
}

function getPlaybackTime() {
  if (player) {
    return player.getCurrentTime();
  }
  return 0.0;
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

function onPlayerReady() {

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
      timerCheckPlaybackTime = setInterval(checkPlaybackTime, 250);
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


function addYouTubeControls() {
  // $("#iframe").bind("durationchange", function() {
  //    alert("Current duration is: " + this.duration);
  // });

  if ($('#iframe'))
  {
    $(window).scroll(function() {
      var topOfDiv = $("#iframe-container").offset().top(); //gets offset of header
      var height = $("#iframe-container").outerHeight(); //gets height of header

      if($(window).scrollTop() > (topOfDiv + height)){
        $("#iframe-controls").show();
        $("#iframe").removeClass("iframe-full-size");
        $("#iframe").addClass("iframe-float-right");
      }
      else {
        $("#iframe-controls").hide();
        $("#iframe").removeClass("iframe-float-right");
        $("#iframe").addClass("iframe-full-size");
      }
    });
  }
}


var ready;
ready = function() {
  addYouTubeControls();
};

$(document).ready(ready);
$(document).on('page:load', ready);



