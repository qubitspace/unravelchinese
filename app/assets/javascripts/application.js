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
//= require jquery_ujs
//= require turbolinks
//= require_tree .


function pauseVideo() {
    document.getElementById('iframe').contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
}
function playVideo() {
    document.getElementById('iframe').contentWindow.postMessage('{"event":"command","func":"playVideo","args":""}', '*');
}

function updatePinnedIframeSize() {
  var iframe = document.getElementById('iframe');
  var iframeWrapper = document.getElementById('iframewrapper');
  var iframeWidth = iframe.offsetWidth;
  var iframeWrapperWidth = iframeWrapper.offsetWidth;

  iframe.height = (iframeWidth * 9) / 16;
  iframeWrapper.height = (iframeWrapperWidth * 9) / 16;
}


function sizeIframe() {
  updatePinnedIframeSize();
  window.addEventListener("resize", function(e) {
    updatePinnedIframeSize();
  });
}


var ready;
ready = function() {
  sizeIframe();

  var topofDiv = $("#iframe").offset().top; //gets offset of header
  var height = $("#iframe").outerHeight(); //gets height of header
  $(window).scroll(function() {
    if($(window).scrollTop() > (topofDiv + height)){
      $("#iframe-controls").show();
    }
    else{
      $("#iframe-controls").hide();
    }
  });



};

$(document).ready(ready);
$(document).on('page:load', ready);



