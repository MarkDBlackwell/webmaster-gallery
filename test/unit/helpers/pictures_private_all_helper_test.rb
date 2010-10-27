module PicturesPrivateAllHelperTest

  private

  def all_pictures
    @pictures = Picture.find(:all)
    gallery
  end

  def all_tags
    @all_tags = Tag.find(:all)
    tags
  end

  def see_output
    f=File.new("#{Rails.root}"\
      '/out/see-output','w')
    f.print rendered
    f.close
  end

end
