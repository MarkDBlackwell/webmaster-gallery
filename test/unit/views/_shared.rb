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

  def base_uri
    Pathname '/webmas-gallery'
  end

  def check_pretty_html_source(*args)
# TODO: remove array, 'type' (just show types in a comment, above). Use undef?
    type   = %w[  section  div            tag  other  ]
    prefix = %w[  <!--     <div\ class="  <           ]
    suffix = %w[  -->      "                          ]
    args.map!{|e| e=[] if e.blank?; e=[e] unless e.kind_of? Array; e}
    args=Array.new(type.length,[]).fill(nil,args.length){|i| args.at i}
# print args.inspect
    source=try(:rendered) || response.body
    big=Regexp.union( (0...args.length).map{|i|
        Regexp.new "#{prefix.at i}#{Regexp.union args.at i}#{suffix.at i}"} )
    line_start=Regexp.new %r"^#{big}"
    nl="\n"
# So far, the application has not required repeating this substitution:
    altered=source.gsub line_start, nl
    s=altered.clone.gsub! big, ''
    return if s.blank?
    anywhere_in_line=s.split nl
    a= altered.split nl
    flunk (0...a.length).reject{|i| a.at(i)==(anywhere_in_line.at i)}.map{|i|
        [(a.at i), (anywhere_in_line.at i), '']}.flatten.join nl
  end

  def delete_picture_files
    @picture_files.each{|e| e.delete}
  end

## gallery_uri
  def filename_matcher(s)
# Keep: may be needed when in sub-URI.
##    prefix='webmas-gallery'
##    Pathname('/').join *[prefix,'images','gallery']
    static_asset_matcher Pathname('images').join *['gallery',s]
  end

  def static_asset_matcher(s)
# TODO def static_asset_matcher(s) # Lost the digits; don't know why.
    e=Regexp.escape base_uri.join(s).to_s
    Regexp.new %r"\A#{e}\d*\z"
  end

  def touch_picture_files(filenames)
    d=DirectoryPicture.gallery_directory
    p=@picture_files=filenames.map{|e| d.join e}
    p.each{|e| FileUtils.touch e}
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
    def +(value) CssString.new [self,value].join '' end

    def instance_of?(t) [CssString,String].member? t end

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
