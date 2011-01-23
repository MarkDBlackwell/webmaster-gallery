require 'test_helper'

class PictureTest < ActiveSupport::TestCase
# %%mo%%pic %%adm%%up

# TODO: try using Rails API's assert_field_type, if I switch to using integer attributes.

  test "model" do
    automatic = %w[ cre  upd ].map{|e| e+'ated_at'}
    static    = %w[              filename  id  sequence ]
    text      = %w[ description  filename  title        ]
    numeric=(r=pictures :two).attributes.keys-text-automatic
# Should include validations for...:
# Numericality:
    assert_validates_numericality_of numeric, :only_integer => true,
        :allow_nil => false
# Uniqueness:
    common = %w[ weight  year ]
    can_be_blank=text-['filename']
    assert_validates_uniqueness_of can_be_blank, :allow_blank => true
    assert_validates_uniqueness_of (all=text+numeric)-can_be_blank-common
# Presence:
    assert_validates_presence_of text
# And...:
# If user input fields have leading or trailing blanks (or plus signs)...:
    correct   = %w[ some-value  2       ]
    pad       =   [ '  ',       '  +  ' ]
    [text-static,numeric-static].zip(correct,pad,[true,false]).
        each do |fields,c,p,b|
      fields.each{|e| r[e]=p+c+p}
# Should strip them before validating and saving (both):
      b ? r.valid? : (r.save :validate => false)
      fields.each{|e| assert_equal c, r[e], e}
    end
# And...:
# The right number of records should be obtained using methods...:
# Find all:
    a=Picture.find :all
    assert_equal 2, a.length
# Find database problems:
    a.each{|e| e.weight=''; e.save :validate => false}
    assert_equal 2, Picture.find_database_problems.length
  end

#-------------
  private

  def assert_validates_numericality_of(*a)
    assert_validates 'Numericality', 'ActiveModel', *a
  end

  def assert_validates_presence_of(*a)
    assert_validates 'Presence', 'ActiveModel', *a
  end

  def assert_validates_uniqueness_of(*a)
    h=2!=a.length ? {} : a.pop
    a.push({:case_sensitive => true}.merge h)
    assert_validates 'Uniqueness', 'ActiveRecord', *a
  end

  def assert_validates(validator,base,methods,options={})
    v=validator
    [methods].flatten.each do |m|
      s="#{m.capitalize}: expected #{v.downcase} validator; found none"
      begin a=@model._validators.fetch m.to_sym
      rescue IndexError; flunk s end
      c=a.select{|e| e.class=="#{base}::Validations::#{v}Validator".constantize}
      assert_present c,s
      c.each{|e| assert_equal options, e.options, m}
    end
  end

  def setup
    @model=Picture
  end

end
