class SharedLayoutTest < SharedViewTest
  helper PicturesHelper

  private

  def render_layout(filename, instance_variables={})
# To achieve the following invocation of render, for example:
#   render :file => Path.root.join('app/views/layouts/application'), :locals =>
#       {:@suppress_buttons => true}
# Invoke in this way:
#   render_layout :@suppress_buttons => true
# Another way to do it:
#    @controller.instance_variable_set(:@suppress_buttons, true)
#-------------
    render :file => filename, :locals => instance_variables
  end

end
