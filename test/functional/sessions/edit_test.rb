require 'test_helper'

class EditSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews filesystem changes.

  test_happy_path_response

  test "routing" do
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => :edit.to_s)
  end

  test "happy path (if logged in)..." do
    happy_path
# Should render edit:
    assert_template :edit
# Should assign:
    %w[approval_group review_groups].each do |e|
      assert_present assigns(e), "Should assign @#{e}"
    end
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :edit
  end

end
