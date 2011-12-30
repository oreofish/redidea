var ideasController = {
    initialized: false, // if event handler are binded, then it's true

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
    
    (function() {	
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
	$(function() { __backtopfuc(); });
     })();
} );
