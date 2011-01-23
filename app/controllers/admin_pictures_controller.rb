class AdminPicturesController < ApplicationController
# %%co%%adm%%ed %%co%%adm%%in %%co%%adm%%filt %%co%%adm%%sh %%co%%adm%%up

  helper PicturesHelper
  before_filter :prepare_single, :except => :index

  def edit
    render_edit
  end

  def index
    @pictures=Picture.order('weight, year DESC, sequence DESC').all
    @editable=true
  end

  def show
    render_show
  end

  def update
    if (p=params[:picture]).present?
      static = %w[ filename id sequence]
# TODO: add tags.
      (%w[description title weight year]-static).each do |e|
        next unless p.has_key? e
        @picture[e]=p.fetch e
      end
      @picture.save :validate => false
    end
    (redirect_back :edit; return) if @picture.invalid?
    render_show
  end

#-------------
  private

  def glom_errors(e)
    e.full_messages.map{|s| s+'.'}.join ' '
  end

  def prepare_single
    (@picture=Picture.find params[:id]).valid?
    @show_filename=true
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
    e=@picture.errors
    flash.now[:error]=(glom_errors e) unless e.empty?
    render template => 'admin_pictures/single'
  end

  def template # For testing purposes.
    :template
  end

end
