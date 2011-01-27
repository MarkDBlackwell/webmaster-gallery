class Tag < ActiveRecord::Base
# %%mo%%tag

  has_many :pictures, :through => :picture_tag_joins, :readonly => true,
      :uniq => true, :validate => false
  has_many                        :picture_tag_joins, :inverse_of => :tag,
      :dependent => :destroy, :autosave => true,
      :uniq => true, :validate => false
end
