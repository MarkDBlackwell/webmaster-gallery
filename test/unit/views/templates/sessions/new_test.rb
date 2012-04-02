require 'test_helper'

class NewSessionsTemplateTest < SharedViewTest
# %%vi%%temp%%ses%%new

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source nil, nil, %w[form  input\ id="password  p]
# The right template:
    assert_template @template
# One password form with method post:
    s=CssString.new 'form'
    assert_single [(s.css_class 'password'),'method'], 'post'
# One form with password field:
    assert_select s.child('input').css_id('password'), 1
# And...:
# Should prompt for password:
    assert_single 'p', %q@Type the password and hit 'Enter'.@
  end

#-------------

  def setup
    render :template => (@template='sessions/new') if @template.blank?
  end

end
