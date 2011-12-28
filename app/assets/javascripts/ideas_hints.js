var ideasController = {
    initialized: false, // if event handler are binded, then it's true
    checkFrequence: 3000,
    lastCheckedCount: 0,

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

    checkFreshIdeas : function() {
        var that = this;
        $.get("/ideas/fresh", function(respone) {
            var new_count = parseInt(respone);
            console.log( "Get fresh ideas: " + new_count );
            if (new_count > that.lastCheckedCount) {
                flashController.doSuccess( "<div class='message notice'><b>有"+respone+"条新点子</b></div>" );
            }
            that.lastCheckedCount = new_count;
        });
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

// handle flash messages and animations
var flashController = {
    doFailure: function(msg) {
        $('.flash').html('<div class="message alert"> '+msg+'  </div>');
        $('.flash .message').show('bounce', { times: 2 }, 1000).hide('fade', {}, 1000);
    }, 
    doSuccess: function(msg) {
        $('.flash').html('<div class="message notice"> '+msg+'  </div>');
        $('.flash .message').effect('fade', {}, 3000);
    }
};

$(document).ready( function() {
    tabsManager.bindHandlers();
    ideasController.init();

    setInterval( function() { ideasController.checkFreshIdeas(); }, 4000);
    //$('.flash').show('bounce', { times: 3}, 500);
} );
