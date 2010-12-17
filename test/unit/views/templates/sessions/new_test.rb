require 'test_helper'

class NewSessionsTemplateTest < SharedViewTest

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source nil, nil, %w[form  input\ id="password  p]
# The right template:
    assert_template @template
# One password form with method post:
    s=CssString.new('form').css_class 'password'
    assert_select s, 1
    assert_select s.attribute('method','post'), 1
# One form with password field:
    assert_select CssString.new('form').child('input').css_id('password'), 1
# And...:
# Should prompt for password:
    assert_select 'p', :count => 1, :text =>
        %q@Type the password and hit 'Enter'.@
  end

#-------------
  private

  def setup
    render :template => (@template='sessions/new') if @template.blank?
  end

end
