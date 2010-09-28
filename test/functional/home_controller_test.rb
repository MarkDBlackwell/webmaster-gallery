require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should redirect to '/pictures'" do
    get :index
    assert_redirected_to :controller => "pictures", :action => "index"
  end

end
