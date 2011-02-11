module ApplicationHelper
# %%vi%%he%%app %%app%%but

  def button(bt,c,a,co=:sessions,m=:get)
    s=content_tag 'div', :class => c do
      button_to bt, {:controller => co, :action => a}, :method => m
    end
    concat s
    nil
  end

end
