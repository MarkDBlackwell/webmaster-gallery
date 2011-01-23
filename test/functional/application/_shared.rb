class SharedApplicationControllerTest < SharedControllerTest
# %%co%%app

  tests ApplicationController

  private

  def expect_redirect_sessions_new
    @controller.expects(:redirect_to).with :controller => :sessions, :action =>
        :new
  end

end
