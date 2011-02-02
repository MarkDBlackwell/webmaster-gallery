require 'test_helper'

class AppTest < ActiveSupport::TestCase
# %%mo%%app

  test "should have methods which..." do
    methods.each do |b,t|
# Have names one level deep (consolidated, not a tree):
      assert_blank [?.,?*].select{|e| t.include? e}, t
# Match the right Rails methods:
      assert_equal eval(b), App.send(t), t
    end
  end

#-------------
#  private

  def arrayify(v)
    (v.kind_of? Array) ? v:[v]
  end

  def dotify(*a)
    a.map(&:to_s).select(&:present?).join '.'
  end

  def methods()
    tips=    [ 'root', %w[ session_options  webmaster ] ]
    branches=[  nil  ,    'config'                      ]
    tips.zip(branches).map do |t,b|
      t,b=[t,b].map{|e| arrayify e}
      t.product(b).map{|t,b| [(dotify 'Gallery::Application',b,t), t]}
    end.flatten 1
  end

end
