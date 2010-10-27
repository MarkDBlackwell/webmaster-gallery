require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# All actions tests:

  test "verify before_filters" do
    assert Date::today < Date::new(2010,10,29), 'Test unwritten.'
#    class AdminPicturesController
#      before_filter :verify_authenticity_token
#    end
#    puts ActionController::Testing::ClassMethods.before_filters
  end

  test "should redirect to new on wrong method" do
# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137

    Restful = Struct.new(:action, :method)
    [   Restful.new(     :edit,   'get'),
        Restful.new(     :index,  'get'),
        Restful.new(     :show,   'get'),
        Restful.new(     :update, 'put'),
        ].each do |proper|
      (ActionController::Request::HTTP_METHODS - [proper[:method]] ).
          each do |bad_method|
        process proper[:action], {:id => '2'}, {:logged_in => true}, nil,
            bad_method
        assert_redirected_to({:controller => :sessions, :action => :new},
            "Action #{proper[:action]}, method #{bad_method}.")
      end
    end
  end

end
