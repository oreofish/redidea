var ideasController = {
    initialized: false, // if event handler are binded, then it's true

    bindIdeaHandler: function() {
        var $idea_content = $('#new_idea #idea_content');
        var $idea_title = $('#new_idea #idea_title');
        var $submit = $("#new_idea :submit");
        var $hint = $('.content .field .num').first();

        var idea_validator = {
            titleInvalid: true,
            contentInvalid: true,

            // set background color to green when title is too long
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

                idea_validator.titleInvalid = (remain <= 0);
            }, 

            // ajax callback, show flash warning of validator
            isSubmitAllow: function(ev, xhr) {
                that = idea_validator;
                if (that.titleInvalid || that.contentInvalid ) {
                    var err_msg = "";
                    if (that.titleInvalid && !that.contentInvalid) {
                        err_msg = "<b>您输入的标题过长或过短</b>";
                    } else if (!that.titleInvalid && that.contentInvalid) {
                        err_msg = "<b>您输入的内容过长或过短</b>";
                    } else {
                        err_msg = "<b>您输入的标题和内容长度不合适</b>";
                    }

                    flashController.doFailure( err_msg );
                    //xhr.abort();
                    return false;
                } 
                return true;
            }, 

            // shortcut of click
            hotkeyHandler : function(e) {
                if (e.ctrlKey && (e.which == 13 || e.which == 10)) {
                    $submit.trigger('click');
                }
            },

            // set background color to red when content is too long.
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
                idea_validator.contentInvalid = (remain <= 0);
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

        $('form#new_idea').bind({
            'ajax:before': idea_validator.isSubmitAllow
        });

        this.initialized = true;
    },

    checkFrequence: 120000,
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
                // find current tab in navigation bar, set activeTab to it.
                var ret = scope_pat.exec( $(el).find('a').attr('href') );
                that.activeTab = ret[1];
                return false;
            }
        });
    },

    bindHandlers: function() {
        var that = this;
        $('.secondary-navigation .wat-cf li').find('a').each( function(idx, el) {
            // binding actions to navigation tabs.
            $(el).bind( {
                // when the tab is clicked, set the tab to active
                'click': function(ev) {
                    $this = $(this);
                    var scope_pat = new RegExp("scope=(.*)", 'g');
                    var ret = scope_pat.exec( $this.attr('href') );
                    that.switchTab( ret[1] );

                    console.log(that.previousTab + "," + that.activeTab + ":focus");
                    // need to reinit to rebind event handlers
                    if (that.activeTab == 'mine') {
                        ideasController.initialized = false;
                        ideasController.init();
                    }
                },

                // ajax:* event handlers used to avoid unnecessary xhr transfer
                'ajax:before': function(ev, xhr) {
                    if (that.previousTab == that.activeTab) {
                        if (!ideasController.hasNewIdeas && !ideasController.hasIdeasDeleted) {
                            // if no update, do not refresh
                            return false;
                        }
                    } 
                    return true;
                },
                'ajax:beforeSend': function(xhr, data, status) {
                    if (that.previousTab == that.activeTab) {
                        if (!ideasController.hasNewIdeas && !ideasController.hasIdeasDeleted) {
                            // if no update, do not refresh
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
        this.stop();
        $('.flash').html('<div class="message alert"> '+msg+'  </div>');
        $('.flash .message').hide().slideDown(500).delay(1000).slideUp(1000);
    }, 
    doFailure: function(msg) {
        this.stop();
        $('.flash').html('<div class="message alert"> '+msg+'  </div>');
        $('.flash .message').show('bounce', { times: 2 }, 1000).hide('fade', {}, 1000);
    }, 
    doSuccess: function(msg) {
        this.stop();
        $('.flash').html('<div class="message notice"> '+msg+'  </div>');
        $('.flash .message').effect('fade', {}, 3000);
    },
    stop: function() {
        $('.flash').stop();
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
    
    var __backtoptxt = "回到顶部";
    var __backtopele = $('<div class="backToTop"></div>').appendTo($("body"))
    .text(__backtoptxt).attr("title", __backtoptxt).click(function() {
        $("html,body").animate({ scrollTop: 0 }, 500);
    }),
    __backtopfuc = function() {
        var st = $(document).scrollTop(),
        winh = $(window).height();
        (st > 0)? __backtopele.show() : __backtopele.hide();
        //IE6
        if (!window.XMLHttpRequest) {
            __backToTopEle.css("top", st + winh - 166);
        }
    };
    $(window).bind("scroll", __backtopfuc);
    __backtopfuc();
} );

