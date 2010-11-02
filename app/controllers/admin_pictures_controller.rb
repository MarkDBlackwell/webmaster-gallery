class AdminPicturesController < ApplicationController
  helper PicturesHelper

  def index
    return unless check_request
    return unless check_logged_in_and_redirect
    @editable = true
    @tags = Tag.all
    @pictures = Picture.all
  end

  def show
    return unless check_request
    return unless check_logged_in_and_redirect
    @picture = Picture.find(params[:id])
    @editable = true
  end

  def edit
    return unless check_request
    return unless check_logged_in_and_redirect
    @picture = Picture.find(params[:id])
  end

  def update
    return unless check_request(request.put?)
    return unless check_logged_in_and_redirect
    @picture = Picture.find(params[:id])
    [:description,:title,:year].each {|e| @picture[e] = params[e]}
    @editable = true
    render :action => @picture.save ? :show : :edit
  end

end
