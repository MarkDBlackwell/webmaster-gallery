class SharedApplicationControllerTest < SharedControllerTest
  tests ApplicationController
# %%co%%app

  private

  def expect_redirect_sessions_new
    @controller.expects(:redirect_to).with :controller => :sessions, :action =>
        :new
  end

end
