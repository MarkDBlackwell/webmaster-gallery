class AdminPicturesController < ApplicationController
  helper PicturesHelper
  before_filter :common_flags
  skip_before_filter :common_flags, :only => :index

  def index
    @pictures = Picture.all
    @editable=true
    @all_tags = Tag.all
  end

  def show
    @editable=true
    @picture = Picture.find(params[:id])
    render 'show'
  end

  def edit
    @edit_fields=true
    @show_labels=true
    @picture = Picture.find(params[:id])
    render 'show'
  end

  def update
    @picture = Picture.find(params[:id])
    pp=params[:picture]
    [:description,:title,:year].each do |e|
      @picture[e]=pp.fetch e if pp.has_key? e
    end unless pp.blank?
    if @picture.save
      @editable=true
    else
      @edit_fields=true
      @show_labels=true
    end
    render 'show'
  end

#-------------
  private

  def common_flags
    @show_filename=true
    @all_tags=Tag.all
  end

end
