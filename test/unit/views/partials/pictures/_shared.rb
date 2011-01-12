class SharedPicturesPartialTest < SharedPartialTest

  private

  def assert_single(selector,value,also_attribute_alone=false)
    if (was_array=selector.kind_of? Array)
      raise unless 2==selector.length
      s,a=*selector
    else
      s=selector
    end
    s||=''
    s=CssString.new(s) unless s.kind_of? CssString
    unless was_array
      assert_select s, 1
      assert_select s, value
    else
      assert_select s, 1 unless s.blank?
      (! also_attribute_alone ? [s] : [s,CssString.new]).each do |e|
        assert_select e.attribute(a), 1
        assert_select e.attribute(a,'?'), value
      end
    end
  end

  def filename_matcher(s)
    e=Regexp.escape "/images/gallery/#{s}?"
    Regexp.new %r"\A#{e}\d+\z"
  end

end
