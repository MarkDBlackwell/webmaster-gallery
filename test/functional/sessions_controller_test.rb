require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# All actions tests:

  test "verify before_filters" do
    assert Date::today < Date::new(2010,10,29), 'Test unwritten.'
#    class SessionsController
#      before_filter :verify_authenticity_token
#    end
#    puts ActionController::Testing::ClassMethods.before_filters
  end

  test "should redirect to new on wrong method" do
# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137

    Restful = Struct.new(:action, :method)
    [   Restful.new(:create,  'post'),
        Restful.new(:destroy, 'delete'),
        Restful.new(:edit,    'get'),
        Restful.new(:new,     'get'),
        Restful.new(:show,    'get'),
        Restful.new(:update,  'put')].each do |rest|
      (ActionController::Request::HTTP_METHODS-[rest[:method]]).each do |method|
        process rest[:action], nil, nil, nil, method
        assert_redirected_to({:action => :new}, "Action #{rest[:action]},"\
          "method #{method}.")
      end
    end
  end

end
