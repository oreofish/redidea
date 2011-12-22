function bindIdeaHandler() {
    var $idea_content = $('#idea_content').first();
    if ($idea_content.length) {
        var $hint = $('.content .field .num').first();

        var idea_validator = {
            hotkeyHandler : function(e) {
                if (e.ctrlKey && e.which == 13) {
                    $('.new_idea :submit').first().trigger('click');
                }
            },

            keyHandler : function(e) {
                var $this = $(this);
                $hint.find('span').html( "" + (400 - $this.attr('value').length) );
            }
        };

        $idea_content.bind({
            'keyup': idea_validator.hotkeyHandler,
            'input': idea_validator.keyHandler,
            'keyup': idea_validator.keyHandler,
            //'compositionend': idea_validator.keyhandler,
            'focusin'   : function() { $hint.fadeIn('slow') },
            'focusout' : function() { $hint.fadeOut('fast') },
        });
    }

}

