require "net/http"
require 'socket'

module ApplicationHelper
  def broadcast(channel,&block)
    message = {:channel => channel, :data => capture(&block),:ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://127.0.0.1:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

end
