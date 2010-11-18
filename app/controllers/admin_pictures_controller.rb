class AdminPicturesController < ApplicationController
  helper PicturesHelper
  before_filter :find_all_tags
  before_filter :find_picture, :except => :index

  def edit
    render_edit
  end

  def index
    @pictures = Picture.all
    @editable=true
  end

  def show
    render_show
  end

  def update
    pp=params[:picture]
# Don't copy filename, id, or sequence.
    [:description,:precedence,:title,:year].each do |e|
      @picture[e]=pp.fetch e if pp.has_key? e
    end unless pp.blank?
    @picture.save ? render_show : render_edit
  end

#-------------
  private

  def find_all_tags
    @all_tags=Tag.all
  end

  def find_picture
    @picture = Picture.find(params[:id])
  end

  def render_edit
    @edit_fields=true
    @show_labels=true
    render_single
  end

  def render_show
    @editable=true
    render_single
  end

  def render_single
    @show_filename=true
# Rendering a partial did not pick up the application layout.
    render :template => 'admin_pictures/single'
  end

end
