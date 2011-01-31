require 'test_helper'

class GetFileAnalysisFilterSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%filt

  test "should..." do
    @filter=:get_file_analysis
# Tell the file models to read:
    %w[FileTag DirectoryPicture].each{|e| e.constantize.expects :read}
    filter
# Assign the analysis to an instance variable:
    assert_present assigns :file_analysis
  end

end
