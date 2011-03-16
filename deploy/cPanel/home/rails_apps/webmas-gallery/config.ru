p Time.now
p 'in '+__FILE__

# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Gallery::Application
