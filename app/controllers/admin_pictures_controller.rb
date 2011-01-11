class AdminPicturesController < ApplicationController
  helper PicturesHelper
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
    @picture.save :validate => false
    (render_show; return) if @picture.valid?
    flash[:error]=glom_errors @picture.errors
    redirect_back :edit
  end

#-------------
  private

  def get_single
# TODO: why here, '@show_filename=true' ?
    @show_filename=true
    @picture=Picture.find params[:id]
  end

  def redirect_back(a)
    begin redirect_to :back
    rescue ActionController::RedirectBackError; redirect_to :action => a end
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

  def glom_errors(e)
    e.full_messages.map{|e| e+'.'}.join ' '
  end

  def template # For testing purposes.
    :template
  end

end
