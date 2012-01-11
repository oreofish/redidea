// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .
$(function(){
    var client = new Faye.Client('http://172.16.82.163:9292/faye');
    var user_email = $("#user-navigation .wat-cf li").eq(0).html();

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
                case "/messages/new":
                    feedback = eval("(" + message['data'] + ")");
                console.log('incoming', user_email + this.update_count);
                if (feedback.user_email != user_email) {
                    this.update_count += 1
                    if (tabsManager.activeTab === "liked") {
                        var link = "<a href='/ideas' class='notify'>更新了"
                        + this.update_count + "个点子，点击查看</a>";
                        $('div.update-notice').html(link);
                    } else {
                        flashController.doMessage("<b>有"+this.update_count+"条新点子</b>" );
                    }
                }
                break;

                case "/messages/destroy":
                    feedback = eval("(" + message['data'] + ")");
                console.log('incoming', user_email + this.destroy_count);
                if (feedback.user_email != user_email) {
                    this.destroy_count += 1
                    if (tabsManager.activeTab === "liked") {
                        var link = "<a href='/ideas' class='notify'>删除了"
                        + this.destroy_count + "个点子，点击刷新</a>";
                        $('div.update-notice').html(link);
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
                }else{
                    callback(message);
                }
            }
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
