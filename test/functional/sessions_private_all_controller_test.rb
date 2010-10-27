module SessionsPrivateAllControllerTest

  private

  def login
    f = File.new("#{Rails.root}"\
      '/test/fixtures/files/file_password/password.txt', 'r')
    clear_text_password = f.readline("\n").chomp "\n"
    f.rewind
    MyFile.expects(:my_new).returns f
    post :create, :password => clear_text_password
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
