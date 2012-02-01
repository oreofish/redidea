// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require ckeditor/ckeditor
//= require_tree .
$(function(){
    var server = location.host.replace(/:\d*/, '');
    if (/localhost/.test(server)) {
        server = '127.0.0.1';
    }
    var client = new Faye.Client('http://'+server+':9292/faye');
    var user_email = $("#user-navigation .wat-cf li").eq(0).html();

    client.subscribe("/ideas/*",function(data){
        //eval(data);
    });

    client.subscribe("/messages/*",function(data){
        eval(data);
    });

    client.subscribe("/users/" + user_email, function(data){
        eval(data);
    });

    // faye 
    Slot = {
        update_count: 0,
        destroy_count: 0,

        incoming: function(message, callback) {
            var feedback, msg;
            switch( message['channel'] ) {
                case "/ideas/new":
                feedback = eval("(" + message['data'] + ")");
                console.log('incoming', user_email + this.update_count);
                if (feedback.user_email != user_email) {
                    this.update_count += 1
                    if (tabsManager.activeTab === "liked") {
                        var link = "<a href='/ideas' class='notify'>更新了"
                        + this.update_count + "个点子，点击查看</a>";
                        $('div.update-notice').html(link);
                        var str="id"+feedback.user_id;
                        $('.block .content .inner .left .user_icon span').each(function(idx, el) {
                            if ($(el).hasClass(str)){
								var cont = $(el).find('b').first();
                                var num=cont.text().match(/\d+/);
                                num=Number(num)+1;
                                cont.text(cont.text().replace(/(\d+)/,num));
                            }
                        })
                    } else {
                        flashController.doMessage("<b>有"+this.update_count+"条新点子</b>" );
                    }
                }
                break;

                case "/ideas/destroy":
                feedback = eval("(" + message['data'] + ")");
                console.log('incoming', user_email + this.destroy_count);
                if (feedback.user_email != user_email) {
                    this.destroy_count += 1
                    if (tabsManager.activeTab === "liked") {
                        var link = "<a href='/ideas' class='notify'>删除了"
                        + this.destroy_count + "个点子，点击刷新</a>";
                        $('div.update-notice').html(link);
                        var str="id"+feedback.user_id;
                        $('.block .content .inner .left .user_icon span').each(function(idx, el) {
                            if ($(el).hasClass(str)){
								var cont = $(el).find('b').first();
                                var num=cont.text().match(/\d+/);
                                num=Number(num)-1;
                                cont.text(cont.text().replace(/(\d+)/,num));
                            }
                        })
                    } else {
                        flashController.doMessage("<b>有"+this.destroy_count+"条点子被删除</b>" );
                    }
                }
                break;

                default:
                if (message['channel'].slice(0,7) == "/users/") {
                    console.log('incoming', message['data']);
                    msg = eval("(" + message['data'] + ")");
                    if (msg.type == 'notify') {
                        $('#chat').append(msg.content);
                    }else if (msg.type == 'message'){
                        $('#chat').append(msg.content);
                    }
                }
            }
            callback(message);
        },
        outgoing: function(message, callback) {
            if (message['channel'] == "/messages/new") {
                console.log('outgoing', message);
            }else{
                callback(message);
            }
        }
    };

    client.addExtension(Slot);

});
