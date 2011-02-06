class SharedViewTest < ActionView::TestCase
# %%vi

  private

  def assert_partial(*args)
    p=c=nil
    [args].flatten.each do |e|
      p=e if e.kind_of? String
      c=e if e.kind_of? Integer
    end
    p=@partial if p.blank?
    c=1 if c.blank?
    # ActionController::TemplateAssertions:
    assert_template :partial => p, :count => c
  end

  def assert_single(selector,value,also_attribute_alone=true)
    if (was_array=selector.kind_of? Array)
      raise unless 2==selector.length
      s,a=*selector
    else
      s=selector
    end
    s||=''
    s=CssString.new(s) unless s.kind_of? CssString
    unless was_array
      assert_select s, 1, s+' count'
      assert_select s, value
    else
      assert_select s, 1 unless s.blank?
      (! also_attribute_alone ? [s] : [s, CssString.new]).each do |e|
        assert_select e.attribute(a), 1
        assert_select e.attribute(a,'?'), value
      end
    end
  end

  def check_pretty_html_source(*args)
    type   = %w[  section  div            tag  other  ]
    prefix = %w[  <!--     <div\ class="  <           ]
    suffix = %w[  -->      "                          ]
    args.map!{|e| e=[] if e.blank?; e=[e] unless e.kind_of? Array; e}
    args=Array.new(type.length,[]).fill(nil,args.length){|i| args.at i}
    source=try(:rendered) || response.body
    big=Regexp.union( (0...args.length).map{|i|
        Regexp.new "#{prefix.at i}#{Regexp.union args.at i}#{suffix.at i}"} )
    line_start=Regexp.new %r"^#{big}"
    nl="\n"
# So far, the application has not required repeating this substitution:
    altered=source.gsub line_start, nl
    s=altered.clone.gsub! big, ''
    return if s.blank?
    anywhere=s.split nl
    a= altered.split nl
    flunk (0...a.length).reject{|i| a.at(i)==(anywhere.at i)}.map{|i| a.at i}.
        join nl
  end

  class CssString < String
    def adjacent( *a) CssString.new a.unshift(self).join ' + ' end
    def child(    *a) CssString.new a.unshift(self).join ' > ' end
    def css_class(*a) CssString.new a.unshift(self).join  '.'  end
    def css_id(   *a) CssString.new a.unshift(self).join  '#'  end
    def descend(  *a) CssString.new a.unshift(self).join  ' '  end

    def first(*a) self.child(*a) + ':first-child' end
    def last( *a) self.child(*a) +  ':last-child' end

    def not(*a)  s=':not('; self + s + a.join( ')'+s) + ')' end
    def +(value) CssString.new [self,value].to_s end

    def attribute(*a)
      odd_p=pairs=(a.length+1)/2
      odd_p -= a.length%2
      r=self.clone
      pairs.times do |i|
        r << '[' + a.shift
        r << '=' + a.shift if i < odd_p
        r << ']'
      end
      CssString.new r
    end

  end

end
