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
                if (e.ctrlKey && (e.which == 13 || e.which == 10)) {
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
            'input keyup': idea_validator.titleValidator
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
    //lastCheckedResponse: 0,
    hasNewIdeas: false,      // this can be used by other objects
    hasIdeasDeleted: false,  // this can be used by other objects

    checkFreshIdeas : function() {
        var that = this;
        $.getJSON("/ideas/fresh", function(respone, status, jqxhr) {
            var log = "";
            $.each(respone, function(key, val) {
                log += "" + key + ":" + val + ", ";
            });
            console.log( "Get Json: " + log );

            var first_respone = false;
            if (typeof that.lastCheckedResponse == "undefined") {
                that.lastCheckedResponse = respone;
                first_respone = true;
            }

            var new_count = respone["fresh"] + respone["liked"];
            var old_count = that.lastCheckedResponse["fresh"] + that.lastCheckedResponse["liked"];

            if (first_respone || respone['fresh'] > that.lastCheckedResponse['fresh']) {
                that.hasNewIdeas = true;
                var new_coming = first_respone? respone['fresh'] : (respone['fresh'] - that.lastCheckedResponse['fresh']);
                flashController.doMessage( "<b>有"+new_coming+"条新点子</b>" );

            } else if (new_count < old_count) {
                flashController.doMessage( "<b>有点子被删除</b>" );
                that.hasIdeasDeleted = true;
            } else {
                that.hasIdeasDeleted = false;
                that.hasNewIdeas = false;
            }
            that.lastCheckedResponse = respone;

            if (tabsManager.activeTab == "liked" && (that.hasNewIdeas || that.hasIdeasDeleted)) {
                console.log('trigger click');
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

    init: function() {
        var that = this;
        var scope_pat = new RegExp("scope=(.*)", 'g');
        $('.secondary-navigation .wat-cf li').each(function(idx, el) {
            if ($(el).hasClass('active')) {
                var ret = scope_pat.exec( $(el).find('a').attr('href') );
                that.activeTab = ret[1];
                return false;
            }
        });
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
    doMessage: function(msg) {
        $('.flash').html('<div class="message alert"> '+msg+'  </div>');
        $('.flash .message').hide().slideDown(500).delay(1000).slideUp(1000);
    }, 
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
    console.log("ready");
    tabsManager.init();
    tabsManager.bindHandlers();
    ideasController.init();

    setInterval( function() { 
        ideasController.checkFreshIdeas(); 
    }, ideasController.checkFrequence );
} );
