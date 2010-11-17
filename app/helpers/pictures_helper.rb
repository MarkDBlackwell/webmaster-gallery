module PicturesHelper

  def alltags
    concat( render :partial => 'pictures/all_tags')
  end

  def field(record,field)
    @edit_fields ? text_field(record, field) : record[field]
  end

  def gallery
    concat( render :partial => 'pictures/gallery')
  end

end
