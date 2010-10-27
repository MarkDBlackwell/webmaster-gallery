module PicturesPrivateHelperTest

  private

  def filename_matcher(s)
    %r@^/images/gallery/#{s}\?\d+$@
  end

  def all_pictures
    @pictures = Picture.find(:all)
    gallery
  end

  def all_tags
    @all_tags = Tag.find(:all)
    tags
  end

  def picture_two
    @pictures = Picture.find(:all)
    pictures(:one).destroy
    gallery
  end

  def see_output
    f=File.new("#{Rails.root}"\
      '/out/see-output','w')
    f.print rendered
    f.close
  end

  def tag_two
# Didn't seem to invoke the ActiveRecord test method, tags:
# ArgumentError: wrong number of arguments (1 for 0)
#    tags(:one).destroy
    @all_tags = Tag.find :all, :conditions => ["name = ?", 'two-name']
    tags
  end

end
