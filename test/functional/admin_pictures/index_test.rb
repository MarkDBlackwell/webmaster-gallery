require 'test_helper'

class IndexAdminPicturesControllerTest < SharedAdminPicturesControllerTest
# %%co%%adm%%in

# -> Webmaster views gallery.

  test_routing_tag # GET
  test_happy_path_response

  test "happy path should..." do
    happy_path
# Render the right template:
    assert_template @action
# Show an edit button:
    assert_flag :editable
# Correctly arrange pictures:
    fields     = %w[ weight  year  sequence ]
    directions = %w[ ASC     DESC  DESC     ]
    by=fields.zip(directions).map{|f,d| f+' '+d}.join ', '
    assert_assigns_order Picture, by
  end

#-------------
  private

  def assert_assigns_order(model,by)
    n=([Picture,DirectoryPicture].include? model) ? :filename : :name
    assert_equal (model.order(by).all.map &n), (assigns(model.to_s.downcase.
        pluralize.to_sym).map &n)
  end

  def happy_path
    pretend_logged_in
    get @action
  end

  def setup
    @controller_name=:admin_pictures.to_s
    @action=:index
  end

end
