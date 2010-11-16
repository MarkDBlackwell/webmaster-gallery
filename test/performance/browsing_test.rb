require 'test_helper'
require 'rails/performance_test_help'
should_include_this_file

# Profiling results for each test method are written to tmp/performance.
class BrowsingTest < ActionDispatch::PerformanceTest

  def test_homepage
    flunk # See if rake task, 'test' runs this file.
    get '/'
  end

end
