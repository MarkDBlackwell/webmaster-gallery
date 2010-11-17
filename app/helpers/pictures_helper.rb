module PicturesHelper

  def alltags
    concat( render :partial => 'pictures/all_tags')
  end

  def field_helper(record,field)
    concat( @edit_fields ? text_field(record, field) : record[field] )
    concat( content_tag :div, raw(" &nbsp; #{field}"), :class => 'label') if
        @show_labels
    nil
  end

  def gallery
    concat( render :partial => 'pictures/gallery')
    nil
  end

end
