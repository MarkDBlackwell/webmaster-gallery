class SharedApplicationControllerTest < SharedControllerTest
  tests ApplicationController

  private

  def expect_sessions_new_redirect
    @controller.expects(:redirect_to).with :controller => :sessions, :action =>
        :new
  end

end
