require 'test_helper'

class PicturePicturesPartialTest < SharedPartialTest

# 13 tests, 33 assertions

  test "should render" do
    assert_template :partial => 'pictures/_picture'
  end

  PREFIX1='div.picture'
  test "should include one picture div" do
    assert_select "#{PREFIX1}", 1
  end

  test "should render a single, right picture" do
    assert_select "#{PREFIX1}[id]", 1
    assert_select "#{PREFIX1}[id=picture_#{@picture.id}]", 1
  end

  PREFIX2='div.picture > form > div.'
  test "should render a single thumbnail within a picture" do
    assert_select "#{PREFIX2}thumbnail", 1
  end

  PREFIX3='div.picture > form > div.field > div.'
  test "should render a single, right year within a picture" do
    has_one "#{PREFIX3}year", '2002'
  end

  %w[description sequence title weight].each do |unique|
    test "should render a single, right #{unique} within a picture" do
      has_one "#{PREFIX3}#{unique}", "two-#{unique}"
    end
  end

  test "should render a single, right filename within a picture if show "\
       "filename" do
    has_one("#{PREFIX3}filename",
        'two.png') {@show_filename = true}
  end

  PREFIX4='div.picture > div.edit'
  test "should render a single edit div within a picture if editable" do
    assert_select "#{PREFIX4}", false
    setup {@editable = true}
    assert_select "#{PREFIX4}", 1
  end

  PREFIX5='div.picture > div.edit > form.button_to'
  test "should render a single button within an edit div if editable" do
    assert_select "#{PREFIX5}", false
    setup {@editable = true}
    assert_select "#{PREFIX5}", 1
  end

  test "rendered button within an edit div should have method get" do
    assert_select "#{PREFIX5}[method]", false
    setup {@editable = true}
    assert_select "#{PREFIX5}[method]", 1
    assert_select "#{PREFIX5}[method=?]", 'get'
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    @picture=pictures(:two)
    render :partial => 'pictures/picture', :locals => {:picture => @picture}
  end

end
