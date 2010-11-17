module PicturesHelper

  def alltags
    concat( render :partial => 'pictures/all_tags')
  end

  def field_helper(record,field)
    s=raw(@edit_fields ? text_field(record, field) : record[field])
    s+=raw(content_tag :div, raw(" &nbsp; #{field}"), :class => 'label') if
        @show_labels
    s
  end

  def gallery
    concat( render :partial => 'pictures/gallery')
  end

end
