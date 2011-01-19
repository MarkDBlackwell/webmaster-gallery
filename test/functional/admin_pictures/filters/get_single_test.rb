require 'test_helper'

class GetSingleFilterAdminPicturesControllerTest <
    SharedAdminPicturesControllerTest
# %%co%%adm%%filt

  test "should..." do
    @controller.params[:id]=pictures(:two).id
    @filter=:get_single
    filter
# TODO: assert something.
  end

end
