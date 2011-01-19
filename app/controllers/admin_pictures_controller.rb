class AdminPicturesController < ApplicationController
  helper PicturesHelper
  before_filter :get_single, :except => :index

  def edit
    render_edit
  end

  def index
    fields     = %w[ weight  year  sequence ]
    directions = %w[ ASC     DESC  DESC     ]
    by=fields.zip(directions).map{|f,d| f+' '+d}.join ', '
    @pictures=Picture.order(by).all
    @editable=true
  end

  def show
    render_show
  end

  def update
    integers= [:weight, :year      ]
    strings=  [:description, :title]
    if (p=params[:picture]).present?
# Don't copy filename, id, or sequence.
      (strings+integers).each do |e|
        next unless p.has_key? e
        value=p.fetch e
# TODO: find another way to remove plus signs.
        begin value=value.to_i.to_s # Regularize plus signs.
        rescue NoMethodError
        end if integers.include? e
        @picture[e]=value
      end
      @picture.save :validate => false
    end
    (redirect_back :edit; return) if @picture.invalid?
    render_show
  end

#-------------
  private

  def get_single
# TODO: why here, '@show_filename=true' ?
    @show_filename=true
    (@picture=Picture.find params[:id]).valid?
  end

  def glom_errors(e)
    e.full_messages.map{|s| s+'.'}.join ' '
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
    flash.now[:error]=glom_errors(e) unless e.empty?
    render template => 'admin_pictures/single'
  end

  def template # For testing purposes.
    :template
  end

end
