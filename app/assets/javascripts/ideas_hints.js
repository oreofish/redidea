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

var commentsManager = {
    bindHandlers: function() {
        var that = this;
        var $items = $('#myideas .item').has('a.comment_link');
        $items.each( function(idx, el) {
            var $link = $(el).find('a.comment_link');

            $link.bind( {
                'click': function(ev) {
                    var $this = $(this);
                    var $box = $this.parents('.item').find('div.comments');
                    $box.toggle('blind');
                }
            });
        });
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

        //that.bindLikingButtons();
    },

    bindLikingButtons: function() {
        var that = this;
        $('#myideas a.small-button').each( function(idx, el) {
            $(el).bind( {
                'ajax:success': function() {
                    // need to reinit to rebind event handlers
                    console.log('liking after: rebind commentsManager');
                    commentsManager.bindHandlers();
                    that.bindLikingButtons();
                }
            });
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
                },
                'ajax:success': function() {
                    console.log('ajax.success');
                    // need to reinit to rebind event handlers
                    if (that.activeTab == 'mine') {
                        ideasController.initialized = false;
                        ideasController.init();
                    } else if (that.activeTab == 'liked') {
                        console.log('rebind commentsManager');
                        commentsManager.bindHandlers();
                        //that.bindLikingButtons();
                    }
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
        $('.flash').css('z-index', 'auto');
        $('.flash .message').hide().slideDown(500).delay(1000).slideUp(1000, function(){
            $('.flash').css('z-index', '-1');
        });
    }, 
    doFailure: function(msg) {
        this.stop();
        $('.flash').html('<div class="message alert"> '+msg+'  </div>');
        $('.flash').css('z-index', 'auto');
        $('.flash .message').show('bounce', { times: 2 }, 1000).fadeOut('slow', function(){
            $('.flash').css('z-index', '-1');
        });
    }, 
    doSuccess: function(msg) {
        this.stop();
        $('.flash').html('<div class="message notice"> '+msg+'  </div>');
        $('.flash').css('z-index', 'auto');
        $('.flash .message').fadeIn('slow').delay(1000).fadeOut('slow', function(){
            $('.flash').css('z-index', '-1');
        });
    },
    stop: function() {
        $('.flash').stop();
    }
};

var chat = {
    messageBox: function() {
        var __box = $('.message_box');
        var __button = $('.button').click(function() {
           __box.toggle();
        });
    }
}

$(document).ready( function() {
    console.log("ready");
    tabsManager.init();
    tabsManager.bindHandlers();
    ideasController.init();
    if (tabsManager.activeTab == 'liked') {
        commentsManager.bindHandlers();
    }

    var url = window.location.pathname;
    if (url == "/messages/new") {
        chat.messageBox();
    }

    var __backtoptxt = "回到顶部";
    var __backtopele = $('<div class="backToTop"></div>').appendTo($("html body"))
    .text(__backtoptxt).attr("title", __backtoptxt).click(function() {
        window.scroll(0, 0);
        //$("html, body").animate({ scrollTop: 0 }, 500);
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

