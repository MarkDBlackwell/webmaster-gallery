class SharedSessionsControllerTest < SharedControllerTest
  tests SessionsController

  private

  def login(p=nil)
    p=get_password unless p.present?
    set_cookies
    post :create, :password => p
  end

  def pictures_in_layouts_directory?
    Path.root.join(*%w[app views layouts pictures.html.erb]).exist?
  end

  def remove_read_permission(path)
    mode=path.stat.mode
    path.chmod(mode ^ 0444) # Remove read permissions.
    begin assert_nothing_raised {yield}
    ensure path.chmod mode end
  end

end
