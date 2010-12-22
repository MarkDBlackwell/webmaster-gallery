class SharedPicturesPartialTest < SharedPartialTest

  private

  def filename_matcher(s)
    e=Regexp.escape "/images/gallery/#{s}?"
    Regexp.new %r"\A#{e}\d+\z"
  end

end
