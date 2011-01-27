class PictureTagJoin < ActiveRecord::Base
# %%mo%%pic %%mo%%tag

  belongs_to :picture, :readonly => true
  belongs_to :tag,     :readonly => true
  validates_uniqueness_of :tag_id,     :scope => :picture_id
  validates_uniqueness_of :picture_id, :scope => :tag_id
  validates_presence_of   :picture_id, :tag_id
# TODO: maybe use (plugin) validates_existence_of :picture_id, :tag_id

end
