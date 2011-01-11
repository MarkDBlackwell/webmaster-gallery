class Picture < ActiveRecord::Base
  numeric,text=[
      %w[ id sequence weight year    ],
      %w[ description filename title ],
      ].map{|e| e.map &:to_sym}
  validates_numericality_of numeric, :only_integer => true
  validates_presence_of     text
  all=numeric+text
  validates_uniqueness_of   all-[:weight,:year]
  all,numeric,text=nil
# Might use this:
#  validates_inclusion_of :weight, :in => ((w=-9..99).map &:to_s), :message =>
#      "is not from '#{w.min}' to '#{w.max}'"

  def self.find_database_problems
    Picture.order(:filename).all.reject{|e| e.valid?}
  end

end
