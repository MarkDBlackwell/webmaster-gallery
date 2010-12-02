class SharedPicturesPartialTest < SharedPartialTest

  private

  def filename_matcher(s)
    %r:^/images/gallery/#{s}\?\d+$:
  end

end
