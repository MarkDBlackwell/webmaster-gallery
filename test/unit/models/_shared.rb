class SharedModelTest < ActiveSupport::TestCase
# %%mo

  private

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

end
