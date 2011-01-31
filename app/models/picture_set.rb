class PictureSet
# %%mo%%ps

  def self.order
    'year DESC, weight, sequence DESC'
  end

  def initialize(tag=nil)
    r=(relation=Picture.order PictureSet.order)
    r=r.joins(:tags).where :tags => {:name => tag} if tag
    r.all
  end

end
