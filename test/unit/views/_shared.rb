class SharedViewTest < ActionView::TestCase

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

  def check_pretty_html_source(*args)
    type   = %w[  section  div            tag  other  ]
    prefix = %w[  <!--     <div\ class="  <           ]
    suffix = %w[  -->      "                          ]
    args.map! {|e| e=[] if e.blank?; e=[e] unless e.kind_of? Array; e}
    args=Array.new(type.length,[]).fill(nil,args.length) {|i| args.at i}
    nl="\n"
    source=nl+rendered
    r=Regexp.union((0...args.length).map {|i|
        Regexp.new "#{prefix.at i}#{Regexp.union args.at i}#{suffix.at i}"})
# So far, the application has not required repeating this substitution:
    altered=source.gsub Regexp.new("#{nl}#{r}"), nl # From line beginnings.
    found=altered.clone.gsub! r, '' # From anywhere in lines.
    return if found.blank?
    a=altered.split nl
    f=found.  split nl
    bad_lines=(0...a.length).reject {|i| f.at(i)==(a.at i)}.
        map {|i| a.at i}.join nl
    see_output bad_lines
    flunk
  end

end
