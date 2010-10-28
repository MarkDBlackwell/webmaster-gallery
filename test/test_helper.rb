ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
%w[ unit/helpers/pictures_private_all_helper
    functional/sessions_private_all_controller
    ].each do |e|
  require File.expand_path("../#{e}_test", __FILE__)
end

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

  def try_wrong_methods(actions, options=nil, params=nil)

# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137

    should_redirect = {:controller => :sessions, :action => :new}
    restful_methods = {
        :create  => 'post',
        :destroy => 'delete',
        :edit    => 'get',
        :index   => 'get',
        :new     => 'get',
        :show    => 'get',
        :update  => 'put',
        }
    actions.each do |action|
      (ActionController::Request::HTTP_METHODS - [restful_methods[action]] ).
          each do |bad_method|
        process action, options, params, nil, bad_method
        assert_redirected_to(should_redirect, "Action #{action}, method #{bad_method}.")
      end
    end
  end

end
