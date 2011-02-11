require 'test_helper'

class ButtonsApplicationPartialTest < SharedPartialTest
# %%vi%%part%%app%%but

  helper ApplicationHelper

  test "should obey the suppress buttons flag" do
    assert_select @dd, 5
    setup{@suppress_buttons=true}
    assert_select @dd, false
  end

  test "happy path should render..." do
# Pretty html source:
    labels,functions = %w[\ pictures  -pictures-index].map{|p|
        %w[admin  user].map{|e| e+p }}
    labels    += %w[  files  database\ problems  log\ out ]
    functions += %w[  edit   show                destroy  ]
    check_pretty_html_source 'Session buttons', functions + [@sb]
# The right partial, once:
    assert_partial
# A single session-buttons div:
    assert_select @ds, 1
# Various button divs:
    assert_select @ds.child(@d), 5
# Various button forms:
    assert_select @f, 5
    assert_select (fb=(@f.css_class 'button_to')), 5
# Most buttons open in the same tab...:
    assert_select fb.not(CssString.new.attribute 'target'), 4
# Except 'user pictures', which opens a new window:
    assert_single [(@d.css_class('user-pictures-index').child @f),'target'],
        '_blank'
# Most use http method, GET...:
    assert_select fb.attribute('method','get'), 4
# Except 'log out', which uses method, POST:
    assert_single [(@d.css_class('destroy').child @f),'method'], 'post', false
    url_options=[
        {:controller => :admin_pictures, :action => :index   },
        {:controller => :pictures,       :action => :index   },
        {:controller => :sessions,       :action => :edit    },
        {:controller => :sessions,       :action => :show    },
        {:controller => :sessions,       :action => :destroy },
        ]
# Various buttons, which should...:
    functions.zip(labels,url_options).each do |f,v,u|
# Be single in their class:
      assert_select (s=(@d.css_class f)), 1, f
# Have the right class:
      assert_select s.child(fb), 1, f
# Be submit buttons:
      sn=s.descend(@i).not CssString.new.attribute 'name'
      assert_single [sn,'type' ], 'submit', false
# Show the right text on their face:
      assert_single [sn,'value'], v,        false
# Link to the right URL:
      assert_single [(s.child @f),'action'], (url_for u), false
    end
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    render_partial 'application/buttons'
    @d,@f,@i = %w[div form input].map{|e| CssString.new e}
    @sb='session-buttons'
    @ds=@d.css_class @sb
    @dd=@ds.descend @d
  end

end
