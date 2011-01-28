class Tag < ActiveRecord::Base
# %%mo%%tag

  has_many :pictures, :through => :picture_tag_joins, :readonly => true,
      :uniq => true, :validate => false
  has_many                        :picture_tag_joins, :inverse_of => :tag,
      :autosave => true, :dependent => :destroy,
      :uniq => true, :validate => false

  validates_presence_of     :created_at,:id,:name,:updated_at
  validates_uniqueness_of   :id,:name
  validates_numericality_of :id, :only_integer => true

end
