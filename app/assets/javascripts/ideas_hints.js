function bindIdeaHandler() {
    var $idea_content = $('#idea_content').first();
    if ($idea_content.length) {
        var $hint = $('.content .field .num').first();

        var idea_validator = {
            keyhandler : function(e) {
                var $this = $(this);
                $hint.find('span').html( "" + (400 - $this.attr('value').length) );
            }
        };

        $idea_content.bind({
            //'keypress': idea_validator.keyhandler,
            'input': idea_validator.keyhandler,
            //'compositionend': idea_validator.keyhandler,
            'focusin'   : function() { $hint.fadeIn('slow') },
            'focusout' : function() { $hint.fadeOut('fast') },
        });
    }

}

