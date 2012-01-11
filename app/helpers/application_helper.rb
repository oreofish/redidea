require "net/http"
module ApplicationHelper
  def broadcast(channel,&block)
    message = {:channel => channel, :data => capture(&block),:ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://127.0.0.1:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end
