class SharedPicturesPartialTest < SharedPartialTest

  private

  def filename_matcher(s)
# TODO: use Regexp.new:
    %r:^/images/gallery/#{s}\?\d+$:
  end

end
