require 'test_helper'

class PrepareSingleFilterAdminPicturesControllerTest <
    SharedAdminPicturesControllerTest
# %%co%%adm%%filt

  tests AdminPicturesController

  test "happy path, for a (URL parameter) picture id, should..." do
# Find its record:
    assert_equal @i, (a=assigns :picture).id
# Run validations on it:
    assert_equal @p.errors, a.errors
# Show its filename:
    assert_flag :show_filename
  end

#-------------

  def setup
    @filter=:prepare_single
    happy_path
  end

  private

  def happy_path
    @i=(@p=pictures :two).id
    @controller.params[:id]=@i
    filter
    @p.valid?
  end

end
