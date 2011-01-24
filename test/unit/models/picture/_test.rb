require 'test_helper'

class PictureTest < ActiveSupport::TestCase
# %%mo%%pic

# TODO: try using Rails API's assert_field_type, if I switch to using integer attributes.

  test "model" do
    automatic = %w[ cre  upd ].map{|e| e+'ated_at'}
    static    = %w[              filename  id  sequence ]
    text      = %w[ description  filename  title        ]
    numeric=(r=@record).attributes.keys-automatic-text
# Should include validations for...:
# Numericality:
    assert_validates_numericality_of numeric, :only_integer => true,
        :allow_nil => false
# Uniqueness:
    multiple = %w[ weight  year ]
    assert_validates_uniqueness_of (numeric+static).uniq-multiple
    assert_validates_uniqueness_of text-static, :allow_blank => true
# Presence:
    assert_validates_presence_of text
# And...:
# The right number of records should be obtained using methods...:
# Find all:
    a=Picture.find :all
    assert_equal 2, a.length
# Find database problems:
    a.each{|e| e.weight=''; e.save :validate => false}
    assert_equal 2, Picture.find_database_problems.length
# And...:
# Should run before validating or saving:
    %w[validation save].each{|e| assert_before_callback :clean_fields, e}
  end

#-------------
  private

  def assert_before_callback(m,e)
    assert_callback m, e, (after=false)
  end

  def assert_callback(method,event,after)
    (r=@record).expects method
    r.run_callbacks(event){after}
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

  def setup
    @model=Picture
    @record=pictures :two
  end

end
