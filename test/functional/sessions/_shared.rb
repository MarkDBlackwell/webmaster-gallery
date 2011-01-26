class SharedSessionsControllerTest < SharedControllerTest
# %%co%%ses

  tests SessionsController

  private

  def login(p=nil)
    p=get_password if p.blank?
    set_cookies
    post :create, :password => p
  end

  def mock_approval_needed(value=true)
    FileAnalysis.any_instance.expects(:approval_needed?).returns value
  end

  def mock_files_invalid(value=true)
    FileAnalysis.any_instance.expects(:files_invalid?).returns value
  end

  def mock_file_analysis(values=[false,false])
# TODO: change to mock_files_invalid & mock_approval_needed.
    [:approval_needed?,:files_invalid?].zip(values).each{|e,v| FileAnalysis.
        any_instance.expects(e).at_least(0).returns v}
  end

  def pictures_in_layouts_directory?
    App.root.join(*%w[app  views  layouts  pictures.html.erb]).exist?
  end

  def remove_read_permission(path)
    mode=path.stat.mode
    path.chmod(mode ^ 0444) # Remove read permissions.
    begin assert_nothing_raised{yield}
    ensure path.chmod mode end
  end

end
