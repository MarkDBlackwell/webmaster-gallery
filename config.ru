# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Gallery::Application

=begin
use Rails::Rack::LogTailer
use ActionDispatch::Static
run ActionController::Dispatcher.new
=end
