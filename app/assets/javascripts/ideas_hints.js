var ideasController = {
    initialized: false, // this handler are binded, then it's true

    bindIdeaHandler: function() {
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
                'keypress': idea_validator.hotkeyHandler,
                'input': idea_validator.keyHandler,
                'keyup': idea_validator.keyHandler,
                //'compositionend': idea_validator.keyhandler,
                'focusin'   : function() { $hint.fadeIn('slow') },
                'focusout' : function() { $hint.fadeOut('fast') },
            });
            this.initialized = true;
        }

    },

    handleIdeaCreate: function() {
        var log_idea_create_success = false;
        $('#new_idea').bind({
            'ajax:failure': function() {
            },
            'ajax:success': function() {
                log_idea_create_success = true;
            },
            'ajax:complete': function() {
                log_idea_create_success = false;
            }
        });
    },

    init: function() {
        if (!this.initialized) {
            this.handleIdeaCreate(); 
            this.bindIdeaHandler();
        }

        if ($('.flash').find('.message').css('display') != "none") {
            $('.flash .message').fadeOut('slow');
        }
    } 
};

