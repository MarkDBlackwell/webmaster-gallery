module PartialTestShared

  private

  def controller_yield
# Without setup_with_controller, another render appends the response, increasing
# any assert_select counts.
    if block_given?
      setup_with_controller
      yield
    end
  end

end
