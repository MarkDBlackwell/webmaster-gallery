class Square   ; def self.new(*a) Hypercube.new 2, *a end end
class Cube     ; def self.new(*a) Hypercube.new 3, *a end end
class Tesseract; def self.new(*a) Hypercube.new 4, *a end end

class Power; def self.new(power,*a) Hypercube.new power, *a end end

class Hypercube
  def self.new(power,array=[0,1])
    p,a=power.to_i,array.to_a
    (2..p).inject(a){|m,trash| m.product a}.flatten.each_slice p
  end
end
