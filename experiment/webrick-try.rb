# Ref.: http://microjet.ath.cx/webrickguide/html/What_is_WEBrick.html

require 'webrick'
include WEBrick

def start_webrick(config = {})
  config.update(
:Port => 13009, # Listening port.
:BindAddress => '127.0.0.1'
)
  server = HTTPServer.new(config)
  yield server if block_given?
  ['INT', 'TERM'].each {|signal|
    trap(signal) {server.shutdown}
  }
  server.start
end
#start_webrick(:DocumentRoot => Dir.pwd)
start_webrick(:DocumentRoot => Dir.pwd)

