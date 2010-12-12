class AdminPicturesController < ApplicationController
  helper PicturesHelper
  before_filter :find_all_tags
  before_filter :get_single, :except => :index

  def edit
    render_edit
  end

  def index
    @pictures=Picture.all
    @editable=true
  end

  def show
    render_show
  end

  def update
    p=params[:picture]
# Don't copy filename, id, or sequence.
    [:description,:title,:weight,:year].each do |e|
      @picture[e]=p.fetch e if p.has_key? e
    end unless p.blank?
    @picture.save ? redirect_to(:action => :show) : render_edit
  end

#-------------
  private

  def find_all_tags
    @all_tags=Tag.all
  end

  def get_single
    @show_filename=true
    @picture=Picture.find params[:id]
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
    render template => 'admin_pictures/single'
  end

  def template # For testing purposes.
    :template
  end

end
