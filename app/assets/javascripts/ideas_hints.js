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

    init: function() {
        if (!this.initialized) {
            this.bindIdeaHandler();
        }

        if ($('.flash').find('.message').css('display') != "none") {
            $('.flash .message').fadeOut('slow');
        }
    } 
};

// tabswitch check
var tabsManager = {
    activeTab : "", 
    previousTab : "",
    switchTab: function(tab) {
        this.previousTab = this.activeTab;
        this.activeTab = tab;
    },
    bindHandlers: function() {
        var that = this;
        $('.secondary-navigation .wat-cf li').find('a').each( function(idx, el) {
            $(el).bind( {
                'click': function(ev) {
                    $this = $(this);
                    var scope_pat = new RegExp("scope=(.*)", 'g');
                    var ret = scope_pat.exec( $this.attr('href') );
                    that.switchTab( ret[1] );

                    console.log(that.previousTab + "," + that.activeTab + ":focus");
                    // need to reinit
                    if (that.activeTab == 'mine') {
                        ideasController.initialized = false;
                        ideasController.init();
                    }
                },
            })
        });

        $('.secondary-navigation .wat-cf li').find('a').each( function(idx, el) {
            $(el).bind({
                'ajax:before': function(ev, xhr) {
                    console.log(that.previousTab + "," + that.activeTab);
                    console.log(this.toString() + ':before');
                    if (that.previousTab == that.activeTab) {
                        return false;
                    } else 
                        return true;
                },
                'ajax:beforeSend': function(xhr, data, status) {
                    console.log(that.previousTab + "," + that.activeTab);
                    console.log(this.toString() + ':beforeSend');
                    if (that.previousTab == that.activeTab) {
                        xhr.abort();
                        return false;
                    } else 
                        return true;
                }
            });
        });
    }
};

//$(document).ready( function() {tabsManager.bindHandlers(); ideasController.init();} );
