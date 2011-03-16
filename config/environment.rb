unless (STARTED_BY_CPANEL='script/rails' != $PROGRAM_NAME)

# Load the rails application

require File.expand_path('../application', __FILE__)

# Initialize the rails application
Gallery::Application.initialize!

else

  load File.expand_path '../../monkey_patch_mongrel_1.1.5/start_webrick.rb', __FILE__

end
