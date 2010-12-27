require 'test_helper'

class GetSingleFilterAdminPicturesControllerTest <
    SharedAdminPicturesControllerTest

  test "should..." do
    @controller.params[:id]=pictures(:two).id
    @controller.send :get_single
  end

end
