require 'test_helper'

class NewSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source nil, nil, %w[form input\ id="password p]
# Should render:
    assert_template @template
# Should have one password form with method post:
    assert_select 'form.password', 1
    assert_select 'form.password[method=post]', 1
# Should have one form with password field:
    assert_select 'form > input#password', 1
# Should prompt for password:
    assert_select 'p', :count => 1, :text =>
        "Type the password and hit 'Enter'."
  end

#-------------
  private

  def setup
    if @template.blank?
      @template='sessions/new'
      render :template => @template
    end
  end

end
