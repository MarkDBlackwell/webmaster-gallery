class Tag < ActiveRecord::Base
# %%mo%%tag

  has_many :pictures, :through => :picture_tag_joins,
      :uniq => true, :readonly => true
  has_many :picture_tag_joins,
      :uniq => true, :readonly => true, :autosave => true

end
