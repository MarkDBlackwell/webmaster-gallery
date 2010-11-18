module PicturesHelper
# Helpers should return nil, always.

  def alltags
    concat( render :partial => 'pictures/all_tags' )
    nil
  end

  def field_helper(record,field)
    value=record[field]
    label=raw(' &nbsp; ').concat field
    uneditable=[:filename]
    plain=(uneditable.include? field) || ! @edit_fields
    hide=:filename==field && ! @show_filename

    return if hide
    concat( plain ? value : text_field_tag(record, field,
        :value => value, :name => "picture[#{field}]") )
    concat( content_tag :div, label, :class => 'label' ) if @show_labels
    nil
  end

  def gallery
    concat( render :partial => 'pictures/gallery' )
    nil
  end

end
