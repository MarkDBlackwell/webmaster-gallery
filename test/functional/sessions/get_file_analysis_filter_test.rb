require 'test_helper'

class GetFileAnalysisFilterSessionsControllerTest < SharedSessionsControllerTest

  test "should..." do
# Tell the file models to read:
    %w[FileTag DirectoryPicture].each{|e| e.constantize.expects :read}
    @filter=:get_file_analysis
    filter
# Assign the analysis to an instance variable:
    assert_present assigns :file_analysis
  end

end
