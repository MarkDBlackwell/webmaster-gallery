class Picture < ActiveRecord::Base

  def self.find_database_problems
    Picture.order(:filename).all
  end

end
