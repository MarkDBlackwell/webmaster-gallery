require 'test_helper'

class ScriptsApplicationPartialTest < SharedPartialTest

  test "scripts div should include certain script tags in order" do
    %w[prototype effects dragdrop controls rails application].
        each_with_index do |e,i|
      assert_select @ds.child('script + '*i).descend('script').attribute('src',
          '?'),
# TODO: use Regexp twice:
          (Regexp.new %Q@/javascripts/#{e}\\.js\\?\\d*\\z@ )
    end
  end

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source 'Scripts', 'scripts', 'script'
# The right partial, once:
    assert_partial
# And...
# Include one scripts div...:
    assert_select @ds, 1
# Which should include six script tags:
    assert_select @dss, 6
    assert_select @dss.attribute('type','text/javascript'), 6
  end

#-------------
  private

  def setup
    render_partial 'application/scripts'
    @d=CssString.new 'div'
    @ds=@d.css_class 'scripts'
    @dss=@ds.descend 'script'
  end

end
