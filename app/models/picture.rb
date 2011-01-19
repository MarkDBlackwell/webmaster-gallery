class Picture < ActiveRecord::Base
  text=         [:description, :filename, :title]
  numeric=      [:id, :sequence, :weight, :year]
  all=          text + numeric
  double_error= text - [:filename]
  common=       [:weight, :year]
  validates_numericality_of numeric, :only_integer => true
  validates_presence_of     text
  validates_uniqueness_of   all - common - double_error
  validates_uniqueness_of   double_error, :allow_blank => true
  all,common,double_error,numeric,text=nil

# Might use this:
#  validates_inclusion_of :weight, :in => ((w=-9..99).map &:to_s), :message =>
#      "is not from '#{w.min}' to '#{w.max}'"

  def self.find_database_problems
    Picture.order(:filename).all.reject{|e| e.valid?}
  end

end
