module PrivateAllLayoutTest

  private

  def render_layout(filename, instance_variables={})
# Sample arguments to render:
#   render :file => "#{Rails.root}/app/views/layouts/application", :locals =>
#       {:@suppress_buttons => true}
# Would be called this way:
#   render_layout :@suppress_buttons => true
# Another way to do it:
#    @controller.instance_variable_set(:@suppress_buttons,true)
#-------------
    render :file => filename, :locals => instance_variables
  end

end
