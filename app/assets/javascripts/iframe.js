$(function() {
    var player = $('iframe');
    var playerOrigin = '*';
    var status = $('.status');

    // Listen for messages from the player
    if (window.addEventListener) {
        window.addEventListener('message', onMessageReceived, false);
    }
    else {
        window.attachEvent('onmessage', onMessageReceived, false);
    }

    // Handle messages received from the player
    function onMessageReceived(event) {
        // Handle messages from the vimeo player only
        if (!(/^https?:\/\/player.vimeo.com/).test(event.origin)) {
            return false;
        }

        if (playerOrigin === '*') {
            playerOrigin = event.origin;
        }

        var data = JSON.parse(event.data);

        switch (data.event) {
            case 'ready':
                onReady();
                break;

            case 'playProgress':
                onPlayProgress(data.data);
                break;

            case 'pause':
                onPause();
                break;

            case 'finish':
                onFinish();
                break;
        }
    }

    // Call the API when a button is pressed
    $('button#play').on('click', function() {
        post('play');
    });

    $('button#pause').on('click', function() {
        post('pause');
    });

    $('button#seek-to').on('click', function() {
        $('this')
        post('playSentence', 30);
    });

    // Helper function for sending a message to the player
    function post(action, value) {
        var data = {
          method: action
        };

        if (value) {
            data.value = value;
        }

        var message = JSON.stringify(data);
        player[0].contentWindow.postMessage(data, playerOrigin);
    }

    function onReady() {
        status.text('ready');

        post('addEventListener', 'pause');
        post('addEventListener', 'finish');
        post('addEventListener', 'playProgress');
    }

    function onPause() {
        status.text('paused');
    }

    function onFinish() {
        status.text('finished');
    }

    function onPlayProgress(data) {
        status.text(data.seconds + 's played');
    }
});

// Change these to be adding/removing classes instead of changing css!
// TODO: use ajax to load and render the form. This way everything is editable but I don't need to load hidden forms everywhere
function addEditIframeAction() {
    $('#edit-iframe-link').click(function() {
        $('.show-iframe').hide();
        $('.edit-iframe').show();
    });

    $('#cancel-edit-iframe-link').click(function() {
        $('.show-iframe').show();
        $('.edit-iframe').hide();
    });
}

var ready;
ready = function() {
    addEditIframeAction();
};

$(document).ready(ready);
$(document).on('page:load', ready);


