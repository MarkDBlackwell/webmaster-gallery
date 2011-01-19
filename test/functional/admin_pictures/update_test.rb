require 'test_helper'

class UpdateAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test "routing" do # PUT
    assert_routing({:path => '/admin_pictures/2', :method => :put},
        :controller => :admin_pictures.to_s, :action => :update.to_s,
        :id => '2')
  end

  test_happy_path_response

  test "happy path..." do
    happy_path
# Should not flash:
    assert_blank [flash[:error],flash[:notice]].to_s
  end

  test "if record fields are invalid..." do
    m = %w[a\ message   another\ one]
    Picture.any_instance.expects(:valid?).at_least_once.returns false
    pretend_logged_in
    put :update, :id => pictures(:two).id
# Should not flash errors here:
    assert_blank flash[:error]
    assert_blank flash[:notice]
# Should redirect to edit:
    assert_redirected_to :action => :edit
  end

#-------------
  private

  def happy_path
    Picture.any_instance.expects(:valid?).at_least_once.returns true
    pretend_logged_in
    put :update, :id => pictures(:two).id
  end

end
