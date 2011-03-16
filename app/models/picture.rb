class Picture < ActiveRecord::Base
# %%mo%%pic

  include ActionView::Helpers::SanitizeHelper

  has_many :tags,     :through => :picture_tag_joins, :readonly => true,
      :uniq => true, :validate => false
  has_many                        :picture_tag_joins, :inverse_of => :picture,
      :autosave => true, :dependent => :destroy,
      :uniq => true, :validate => false

##  validates_presence_of     :created_at,:description,:filename,:id,:title,
##      :updated_at

  validates_presence_of     :created_at,:filename,:id,:title,:updated_at
  validates_length_of       :year, :is => 4
  validates_uniqueness_of   :filename,:id,:sequence
##  validates_uniqueness_of   :description,:title, :allow_blank => true

  validates_uniqueness_of   :title, :allow_blank => true
  validates_numericality_of :id,:sequence,:weight,:year, :only_integer => true
  before_validation :clean_fields
  before_save       :clean_fields

  def self.find_database_problems
    Picture.order(:filename).all.reject{|e| e.valid?}
  end

#-------------
  private

  def clean_fields
    %w[ weight  year       ].each{|e| self[e]=clean_numeric self[e]||'', e}
    %w[ description  title ].each{|e| self[e]=clean_text    self[e]||'', e}
    true
  end

  def clean_numeric(v,a)
    v=v.gsub '+', '' unless v.index ?-
    clean_text v, a
  end

  BREAK_TAG = 'br' # To narrow picture divs, allow break tags in text.
  BREAK_TAG_STRIPPED = "<#{BREAK_TAG} />"
  GREEDY_WHITESPACE = '\s*'
  ZERO_OR_ONE_OCCURRENCE='?'
  BREAK_TAG_REGEXP = Regexp.new [ nil,
      Regexp.escape('<'),
      Regexp.escape(BREAK_TAG),
      Regexp.escape('/') + ZERO_OR_ONE_OCCURRENCE,
      Regexp.escape('>'),
      nil ].join(GREEDY_WHITESPACE), Regexp::IGNORECASE, 'u'

  def clean_text(v,a)
# This is the use, per: http://wonko.com/post/sanitize
##    v=Sanitize.clean v, elements=[BREAK_TAG], attributes={}, protocols={}

# TODO: Somehow, <b> tags still remain.
    v=v.gsub BREAK_TAG_REGEXP, BREAK_TAG_STRIPPED
    v=sanitize v.strip, :tags => BREAK_TAG, :attributes => []
    v=v.gsub %q("), '&#34;'
    v=v.gsub %q('), '&#39;'
    return v if v.present?
    case a
    when 'weight' then '0'
    when 'year' then Time.now.year.to_s
    else v end
  end

end
