class SharedPartialTest < SharedViewTest

  private

  def has_one(selector,v)
    innermost=selector.split(' ').last
    values=[v,'']
    final=0
    (block_given? ? 1 : final).downto final do |i|
      in_final = final==i
      values.reverse! if in_final
      assert_select selector, :count => 1 do
        values.each_with_index do |text, count|
          assert_select innermost, :text => text, :count => count
        end
      end
      setup {yield} unless in_final
    end
  end

  def controller_yield
# Without setup_with_controller, another render appends the response, increasing
# any assert_select counts.
    if block_given?
      setup_with_controller
      yield
    end
  end

end
