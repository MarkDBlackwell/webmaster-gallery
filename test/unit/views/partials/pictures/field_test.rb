require 'test_helper'

class FieldPicturesPartialTest < SharedPicturesPartialTest
# %%vi%%part%%pic%%fie

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source nil, 'field'
# The right partial, once:
    assert_partial
# One field div:
    assert_select @df, 1
# Div for field:
    assert_select @dt, 1
# A model attribute:
    assert_single @dft, @field
  end

  test "whether show_filename..." do
    f='filename'
    s=@df.child('div').css_class f
    assert_select s, false
    setup('filename'){@show_filename=true}
# Should render a single, right filename:
    assert_single s, @field
# Without input:
    assert_select s.child('input'), false
  end

  test "whether edit_allowed..." do
    not_test = %w[ filename ]
    automatic = %w[ id ] + %w[ cre  upd ].map{|e| e+'ated_at'}
    attributes=Picture.column_names
    (attributes-automatic-not_test).sort.each do |f|
      s=@df.child('div').css_class f
      reset_flags f
      if %w[ sequence weight ].include? f
        assert_single s, ''
      else
        assert_single s, @field
      end
      setup(f){@edit_allowed=true}
      assert_single s, @field
    end
  end

  test "whether show_labels..." do
    automatic = %w[ id ] + %w[ cre  upd ].map{|e| e+'ated_at'}
    attributes=Picture.column_names
    (attributes-automatic).sort.each do |f|
      s=CssString.new('div').css_class(f).child('div').css_class 'label'
      reset_flags f
      if %w[ title year ].include? f
# Should render a single, right label:
        assert_single s, "&nbsp; #{f}"
      else
        assert_select s, false
      end
      setup(f){@show_labels=true}
      if %w[ filename sequence weight].include? f
        assert_select s, false
      else
        assert_single s, "&nbsp; #{f}"
      end
      setup(f){@show_filename=@show_labels=true}
      if %w[ sequence weight].include? f
        assert_select s, false
      else
        assert_single s, "&nbsp; #{f}"
      end
      setup(f){@edit_allowed=@show_labels=true}
      assert_single s, "&nbsp; #{f}"
      setup(f){@editing=@show_labels=true}
      assert_single s, "&nbsp; #{f}"
      setup(f){@edit_allowed=@editing=@show_labels=true}
      assert_single s, "&nbsp; #{f}"
    end
  end

  test "whether editing..." do
    not_test = %w[ filename ]
    automatic = %w[ id ] + %w[ cre  upd ].map{|e| e+'ated_at'}
    attributes=Picture.column_names
    (attributes-automatic-not_test).sort.each do |f|
      s=@df.child('div').css_class f
      reset_flags f
      si=s.child 'input'
      assert_select si, false
# TODO: Why weight?
      if %w[ sequence weight ].include? f
        assert_single s, ''
      else
        assert_single s, @field
      end
      setup(f){@editing=true}
      if %w[ sequence ].include? f
        assert_single s, @field
        assert_select si, false
      else
        assert_single s, '' 
        assert_single si, ''
        assert_single [si,'name'], "picture[#{f}]"
        assert_single [si,'type'], 'text'
        assert_single [si,'value'], @field
      end
    end
  end

#-------------
  private

  def reset_flags(field)
    setup(field){@editing=@edit_allowed=@show_filename=nil}
  end

  def setup(field='title',&block)
# Naming this method, 'render', then using 'super', failed somehow.
    controller_yield &block
    c=:pictures
    @controller.default_url_options={:controller=>c}
    record=Picture.new
    record[field]=(@field="some #{field} value")
    render_partial 'pictures/field', :record => record, :field => field.to_sym
    @df,@dl,@dt = %w[ field label title ].
        map{|e| CssString.new('div').css_class e}
    @dft=@df.child @dt
  end

end
