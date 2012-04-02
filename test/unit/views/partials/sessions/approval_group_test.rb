require 'test_helper'

class ApprovalGroupSessionsPartialTest < SharedPartialTest
# %%vi%%part%%ses%%ag

  test "happy path should render..." do
# The right partial, once:
    assert_partial
# A single...:
# Approval div:
    assert_select @da, 1, @da
# Submit button:
    assert_select @is, 1, @b
# Form...:
    assert_select @da.child(@f), 1, @f
# Which is an approval form...:

## filename_matcher
## gallery_directory
## gallery_uri

    assert_single [@f,'action'], (base_uri.join 'session')
    assert_single [@f,@m], 'post'
# Which should...:
# Indicate the http method, PUT:
    assert_single [@f.child(@d,@ih).attribute('name', '_'+@m), @v], 'put', false
# Include a submit button...:
# On which should be the appropriate text:
    assert_single [(@f.child @is), @v], @group.message, false
# Containing the appropriate approval group:
    assert_single [(@f.child @ih), @v], @group.list, false
# Include a hidden input...:
    %w[name id].each{|e| assert_single [(@f.child @ih), e], @a+'_group', false}
  end

#-------------

  def setup
    c=:sessions
    @controller.default_url_options={:controller=>c}
    @group=Struct.new(:list,:message).new 'some-list', 'some-message'
    render_partial 'sessions/approval_group', :approval_group => @group
    @a,@b,@d,@f,@i,@m,@v = %w[
        approval  button  div  form  input  method  value
        ].map{|e| CssString.new e}
    @ih,@is = %w[hidden  submit].map{|e| @i.attribute 'type', e}
    @da=@d.css_class 'approve'
  end

end
