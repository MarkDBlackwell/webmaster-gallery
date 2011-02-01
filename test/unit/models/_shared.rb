class SharedModelTest < ActiveSupport::TestCase
# %%mo

  private

  def assert_validates(validator,base,methods,options={})
    v=validator
    [methods].flatten.each do |m|
      s="#{m.to_s.capitalize} #{v.downcase} validator not found"
      begin a=@model._validators.fetch m.to_sym
      rescue IndexError; flunk s end
      c=a.select{|e| e.class=="#{base}::Validations::#{v}Validator".constantize}
      assert_present c,s
      c.each do |e|
        eo=e.options.reject{|k,t| :tokenizer==k}
        assert_equal options, eo, s+' with options'
      end
    end
  end

  def assert_validates_length_of(*a)
    assert_validates 'Length', 'ActiveModel', *a
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
