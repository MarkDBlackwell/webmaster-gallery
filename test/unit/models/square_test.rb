require 'test_helper'

class SquareTest < ActiveSupport::TestCase
# %%mo%%sq

  test "..." do
    v=[0,1    ]; assert_equal [v],    Square.new.select{|e| e==v}
    v=[0,1,0  ]; assert_equal [v],      Cube.new.select{|e| e==v}
    v=[0,1,0,0]; assert_equal [v], Tesseract.new.select{|e| e==v}

    hypercube=vector= %w[a b c]
    1.upto(4) do |power|
      hypercube=hypercube.product vector if power >= 2
      sliced=hypercube.flatten.each_slice(power).to_a
      literal=case power
      when 1 then %w[a b c]
      when 2 then %w[aa ab ac ba bb bc ca cb cc]
      when 3 then %w[aaa aab aac aba abb abc aca acb acc baa bab bac bba bbb bbc
          bca bcb bcc caa cab cac cba cbb cbc cca ccb ccc]
      end
      assert_equal literal, sliced.map{|e| e.join ''} if power <= 3
      assert_equal sliced, Hypercube.new(power, vector).to_a
    end
  end

end
