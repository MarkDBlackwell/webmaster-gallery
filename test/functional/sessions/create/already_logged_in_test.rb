require 'test_helper'

class AlreadyLoggedInCreateSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%cr%%

  test "without password..." do
    post :create
    shoulds
  end

  test "when password wrong" do
    post :create, :password => 'example wrong password'
    shoulds
  end

#-------------
  private

  def setup
    pretend_logged_in
  end

  def shoulds
# Should flash:
    assert_equal 'You already were logged in.', flash[:notice]
    assert_blank flash[:error]
# Should redirect to edit:
    assert_redirected_to :action => :edit
  end

end
