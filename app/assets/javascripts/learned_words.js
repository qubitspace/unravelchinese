
function updateLearnedWordStatus(wordId, status) {
  if (status == "known") {
    setWordKnown(wordId);
  } else if (status == "unknown") {
    setWordUnknown(wordId);
  }
}

function setWordKnown(wordId) {
  var wordId = wordId;
  $('div[wordId="' + wordId + '"]').each(function() {
    $(this).removeClass("unknown");
    $(this).addClass("known");
  });
}

function setWordUnknown(wordId) {
  var wordId = wordId;
  $('div[wordId="' + wordId + '"]').each(function() {
    $(this).removeClass("known");
    $(this).addClass("unknown");
  });
}