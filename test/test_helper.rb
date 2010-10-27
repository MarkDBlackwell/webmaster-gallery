ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path('../unit/helpers/pictures_private_all_helper_test', __FILE__)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def see_output
    f=File.new("#{Rails.root}/out/see-output",'w')
    begin
      f.print rendered
    rescue NameError
    end
    begin
      f.print response.body
    rescue NameError
    end
    f.close
  end

end
