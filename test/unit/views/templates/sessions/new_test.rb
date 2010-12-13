require 'test_helper'

class NewSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source nil, nil, %w[form  input\ id="password  p]
# Should render the right template:
    assert_template @template
# Should have one password form with method post:
    assert_select (s='form.password'), 1
    assert_select s+'[method=post]', 1
# Should have one form with password field:
    assert_select 'form > input#password', 1
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
