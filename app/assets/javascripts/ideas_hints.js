var ideasController = {
    initialized: false, // if event handler are binded, then it's true

    bindIdeaHandler: function() {
        var $idea_content = $('#new_idea #idea_content');
        var $idea_title = $('#new_idea #idea_title');
        var $submit = $("#new_idea :submit");
        var $hint = $('.content .field .num').first();

        var idea_validator = {
            titleValidator: function() {
                var $this = $(this);
                var remain = (30 - $this.attr('value').length);

                $this.stop(); // stop previous animation
                if (remain < 0) {
                    $this.animate({
                        backgroundColor: "#00aa00",
                        color: "#fff"
                    }, 1000 );
                } else {
                    $this.animate({
                        backgroundColor: "#fff",
                        color: "#000"
                    }, 1000 );
                }
            }, 

            hotkeyHandler : function(e) {
                if (e.ctrlKey && e.which == 13) {
                    $submit.trigger('click');
                }
            },

            keyHandler : function(e) {
                var $this = $(this);
                var remain = (400 - $this.attr('value').length);
                $hint.find('span').html( remain.toString() );

                $this.stop(); // stop previous animation
                if (remain < 0) {
                    $this.animate({
                        backgroundColor: "#aa0000",
                        color: "#fff"
                    }, 1000 );
                } else {
                    $this.animate({
                        backgroundColor: "#fff",
                        color: "#000"
                    }, 1000 );
                }
            }
        };

        $idea_title.bind({
            'input': idea_validator.titleValidator
        });

        $idea_content.bind({
            'keypress': idea_validator.hotkeyHandler,
            'input': idea_validator.keyHandler,
            'keyup': idea_validator.keyHandler,
            //'compositionend': idea_validator.keyhandler,
            'focusin'   : function() { $hint.fadeIn('slow') },
            'focusout' : function() { $hint.fadeOut('fast') },
        });
        this.initialized = true;
    },

    checkFrequence: 10000,
    lastCheckedCount: 0,
    hasNewIdeas: false,      // this can be used by other objects
    hasIdeasDeleted: false,  // this can be used by other objects

    checkFreshIdeas : function() {
        var that = this;
        $.get("/ideas/fresh", function(respone) {
            var new_count = parseInt(respone);
            console.log( "Get fresh ideas: " + new_count );
            if (new_count > that.lastCheckedCount) {
                that.hasNewIdeas = true;
                flashController.doSuccess( "<b>有"+respone+"条新点子</b>" );

            } else if (new_count < that.lastCheckedCount) {
                flashController.doSuccess( "<b>有点子被删除</b>" );
                that.hasIdeasDeleted = true;
            } else {
                that.hasIdeasDeleted = false;
                that.hasNewIdeas = false;
            }
            that.lastCheckedCount = new_count;

            if (tabsManager.activeTab == "liked") {
                //TODO: need refinement
                $('.secondary-navigation .wat-cf li a').filter(function(idx) {
                    return $(this).attr('href').indexOf(tabsManager.activeTab) >= 0;
                }).trigger('click');
            }
        });
    }, 

    // this needs to get called when tab 'mine' activated
    reinit: function() {
        this.initialized = false;
        this.init();
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
                'ajax:before': function(ev, xhr) {
                    if (that.previousTab == that.activeTab) {
                        if (!ideasController.hasNewIdeas && !ideasController.hasIdeasDeleted) {
                            return false;
                        }
                    } 
                    return true;
                },
                'ajax:beforeSend': function(xhr, data, status) {
                    if (that.previousTab == that.activeTab) {
                        if (!ideasController.hasNewIdeas && !ideasController.hasIdeasDeleted) {
                            xhr.abort();
                            return false;
                        }
                    } 
                    return true;
                }
            })
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

    setInterval( function() { 
        ideasController.checkFreshIdeas(); 
    }, ideasController.checkFrequence );
} );
