class Picture < ActiveRecord::Base
# %%mo%%pic

  include ActionView::Helpers::SanitizeHelper

  has_many :tags,     :through => :picture_tag_joins, :readonly => true,
      :uniq => true, :validate => false
  has_many                        :picture_tag_joins, :inverse_of => :picture,
      :autosave => true, :dependent => :destroy,
      :uniq => true, :validate => false

  validates_presence_of     :created_at,:description,:filename,:id,:title,
      :updated_at
  validates_uniqueness_of   :filename,:id,:sequence
  validates_uniqueness_of   :description,:title, :allow_blank => true
  validates_numericality_of :id,:sequence,:weight,:year, :only_integer => true
  before_validation :clean_fields
  before_save       :clean_fields

  def self.find_database_problems
    Picture.order(:filename).all.reject{|e| e.valid?}
  end

#-------------
  private

  def clean_fields
    %w[ weight  year       ].each{|e| clean_numeric e}
    %w[ description  title ].each{|e| clean_text    e}
    true
  end

  def clean_numeric(a)
    self[a]=(self[a]||'').gsub '+', ''
    clean_text a
  end

  def clean_text(a)
    v=self[a] || ''
    self[a]=sanitize v.strip, :tags => []
  end

end
