module PicturesHelper

  def tags
    concat_raw '<div class="all-tags"></div>'
  end

  def gallery
    concat_raw '<div class="gallery">'
    Picture.all.each do |e|
      extension = File.extname e.filename
      path = e.filename.chomp(extension) + '-t' + extension
      concat( render :partial => 'picture',
          :locals => {:picture => e, :path => path} )
    end
    concat_raw '</div>'
  end

  private

  def concat_raw s
    concat( raw s)
  end

end
