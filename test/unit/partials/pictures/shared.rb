class PicturesPartialTest < ActionView::TestCase

  private

  def filename_matcher(s)
    %r:^/images/gallery/#{s}\?\d+$:
  end

end
