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
    var client = new Faye.Client('http://localhost:9292/faye');
    client.subscribe("/messages/new",function(data){
        eval(data);
    });

    // faye log
    Logger = {
        update_count: 0,

        incoming: function(message, callback) {
            if (message['channel'] == "/messages/new") {
                var feedback = eval("(" + message['data'] + ")");
                var user_email = $("#user-navigation .wat-cf li").eq(0).html();
                if (feedback.user_email != user_email) {
                    this.update_count += 1
                    var link = "<a href='/ideas' class='notify'>更新了"
                        + this.update_count + "个点子，点击查看</a>";
                    $('div.update-notice').html(link);
                }
                console.log('incoming', user_email + this.update_count);
            }else{
                callback(message);
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

    client.addExtension(Logger);

});
