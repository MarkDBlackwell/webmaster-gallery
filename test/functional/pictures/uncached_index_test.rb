require 'test_helper'

class UncachedIndexPicturesControllerTest < SharedControllerTest
  tests PicturesController

  [{:tag=>'some_tag'},Hash.new].each do |e|
    s=e.inspect
    2.times do |i|
      test "should be no route for action, 'uncached_index' on #{[s,i]}" do
        a=[:uncached_index, e]
        assert_raise ActionController::RoutingError do
          try_route *a if 0==i
          get *a       if 1==i
        end
      end
    end
    test "on the other hand, index should be okay on #{s}" do
      a=[:index, e]
      try_route *a
      get *a
    end
  end

#-------------
  private

  def try_route(action,hash)
    route = hash.empty? ? '' : "pictures/#{hash[:tag]}"
    assert_generates route, {:controller => :pictures, :action => action}.
        merge(hash), {}, {}, "route #{route}"
  end

end
