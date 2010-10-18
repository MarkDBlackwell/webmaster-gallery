module PicturesHelper

  def tags
    concat_raw '<div class="all-tags"></div>'
  end

  def gallery
#print '@pictures: '; p @pictures
#    concat( render :partial => 'gallery', :local => {:pictures => @pictures} )
    concat( render :partial => 'gallery')
=begin
    concat_raw "<%= content_tag :div, :class => 'gallery' do %>"
    concat_raw "<%=   div_for picture do %>"
    concat_raw "<%=     content_tag :div, :class => 'thumbnail' do %>"
    concat_raw "<%=       extension = File.extname picture.filename %>"
    concat_raw "<%=       thumbnail_source = picture.filename.chomp(extension) + '-t' + extension %>"
    concat_raw "<%=       image_tag thumbnail_source, :alt => picture.title %>"
    concat_raw "<%=     end %>"
    concat_raw "<%=     content_tag :div, picture.title, :class => 'title' %>"
    concat_raw "<%=     content_tag :div, picture.description, :class => 'description' %>"
    concat_raw "<%=     content_tag :div, picture.year, :class => 'year' %>"
    concat_raw "<%=   end %>"
    concat_raw "<%= end %>"
=end
  end

  def pictures_helper( pictures)
#    concat( render :partial => 'picture', :collection => pictures)
  end

  private

  def concat_raw s
    concat( raw s)
  end

end
