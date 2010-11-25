class SharedSessionsControllerTest < SharedControllerTest
  tests SessionsController

  private

  def login(p=nil)
    p=get_password unless p.present?
    set_cookies
    post :create, :password => p
  end

  def pictures_in_layouts_directory?
    File.exists? "#{Rails.root}/app/views/layouts/pictures.html.erb"
  end

  def remove_read_permission(path)
    mode=File.stat(path).mode
    File.chmod(mode ^ 0444, path) # Remove read permissions.
    begin
      yield
    rescue Errno::EACCES
      flunk
    ensure
      File.chmod(mode, path)
    end
  end

end
