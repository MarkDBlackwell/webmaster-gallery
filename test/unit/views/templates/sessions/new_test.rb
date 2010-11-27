require 'test_helper'

class NewSessionsTemplateTest < SharedViewTest

  test "should render" do
    assert_template @template
  end

  test "should render pretty html source" do
    check_pretty_html_source nil, nil, %w[form input\ id="password p]
  end

  test "should have one password form with method post" do
    assert_select 'form.password', 1
    assert_select 'form.password[method=post]', 1
  end

  test "should have one form with password field" do
    assert_select 'form > input#password', 1
  end

  test "should prompt for password" do
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
