class Picture < ActiveRecord::Base
# %%mo%%pic %%mo%%adm%%up

  validates_numericality_of :id, :sequence, :weight, :year, :only_integer =>
      true
  validates_presence_of     :description, :filename, :title
  validates_uniqueness_of   :filename, :id, :sequence
  validates_uniqueness_of   :description, :title, :allow_blank => true
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
  end

  def clean_numeric(a)
    self[a]=(self[a]||'').gsub '+', ''
    clean_text a
  end

  def clean_text(a)
    self[a]=(self[a]||'').strip
  end

end
