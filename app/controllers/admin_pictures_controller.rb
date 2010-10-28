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
  end

  def edit
    return unless check_request
    return unless check_logged_in_and_redirect
    @picture = Picture.first
  end

  def update
    return unless check_request(request.put?)
    return unless check_logged_in_and_redirect
    render :action => :show
  end

end
