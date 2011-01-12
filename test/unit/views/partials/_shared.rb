class SharedPartialTest < SharedViewTest

  private

  def controller_yield
# Without setup_with_controller, another render appends the response, increasing
# any assert_select counts.
    (setup_with_controller; yield) if block_given?
  end

  def render_partial(p,local_assigns={})
    # ActionView::TestCase::Behavior#, which invokes ActionView::Rendering#:
    if local_assigns.blank? # Work around bugs:
      render :partial => p
    else
      render p, local_assigns
    end
    @partial=p.clone.insert p.index(?/)+1, '_'
  end

end
