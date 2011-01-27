class PictureTagJoin < ActiveRecord::Base
# %%mo%%pic %%mo%%tag

  belongs_to :picture, :inverse_of => :picture_tag_joins,
      :readonly => true, :autosave => false
  belongs_to :tag,     :inverse_of => :picture_tag_joins,
      :readonly => true, :autosave => false
  validates_uniqueness_of :tag_id,     :scope => :picture_id
  validates_uniqueness_of :picture_id, :scope => :tag_id
  validates_presence_of   :picture_id, :tag_id
# TODO: maybe use (plugin) validates_existence_of :picture_id, :tag_id

end
