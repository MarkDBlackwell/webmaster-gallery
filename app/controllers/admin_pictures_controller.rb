class AdminPicturesController < ApplicationController
  helper PicturesHelper

  def index
    return unless check_request
    return unless check_logged_in_and_redirect
    @editable=true
    @tags = Tag.all
    @pictures = Picture.all
  end

  def show
    return unless check_request
    return unless check_logged_in_and_redirect
    @show_filename=true
    @editable=true
    @picture = Picture.find(params[:id])
    render :action => :edit # Show the record.
  end

  def edit
    return unless check_request
    return unless check_logged_in_and_redirect
    @show_filename=true
    @edit_fields=true
    @picture = Picture.find(params[:id])
  end

  def update
    return unless check_request(request.put?)
    return unless check_logged_in_and_redirect
    @picture = Picture.find(params[:id])
    pp=params[:picture]
    [:description,:title,:year].each do |e|
      @picture[e]=pp.fetch e if pp.has_key? e
    end unless pp.blank?
    @show_filename=true
    if @picture.save
      @editable=true
#      render :action => :show
      render :action => :edit # Show the record.
    else
      @edit_fields=true
      render :action => :edit
    end
  end

end
