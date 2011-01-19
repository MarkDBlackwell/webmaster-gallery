# %%mo%%sq

class Square   ; def self.new(*a) Hypercube.new 2, *a end end
class Cube     ; def self.new(*a) Hypercube.new 3, *a end end
class Tesseract; def self.new(*a) Hypercube.new 4, *a end end

class Power; def self.new(power,*a) Hypercube.new power, *a end end

class Hypercube
# Gives, e.g. every triplet from a triplicated vector.
# Usage examples:
#   Hypercube.new(3, (0..7).to_a).map{|i,j,k| block}
#   Square.new.map{|i,j| block}
#   Cube.new.map{|i,j,k| block}

  def self.new(power,array=[0,1])
    p,a=power.to_i,array.to_a
    (2..p).inject(a){|m,trash| m.product a}.flatten.each_slice p
  end
end
