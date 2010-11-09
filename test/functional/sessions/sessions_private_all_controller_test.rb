module SessionsPrivateAllControllerTest

  private

  def login(password=nil)
    f=File.new("#{Gallery::Application.config.webmaster}/password.txt", 'r')
    if password.nil?
      password = f.readline("\n").chomp "\n"
      f.rewind
    end
    MyFile.expects(:my_new).returns f
    request.cookies[:not_empty]='not_empty'
    post :create, :password => password
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
