require 'test_helper'

class PictureTest < ActiveSupport::TestCase
# %%mo%%pic

  test "..." do
# Should include validations for...:
    t = %w[ description title filename ]
    n = %w[ id sequence weight year    ]
# Numericality:
    assert_validates_numericality_of n, :only_integer => true, :allow_nil =>
        false
# Uniqueness:
    assert_validates_uniqueness_of (n.take 2)<<t.last
    assert_validates_uniqueness_of (t.take 2), :allow_blank => true
# Presence:
    assert_validates_presence_of t
# Find methods should get the right number of records...:
# Find all:
    assert_equal 2, Picture.find(:all).length
# Find database problems:
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
