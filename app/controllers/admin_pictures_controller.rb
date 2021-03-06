class AdminPicturesController < ApplicationController
# %%co%%adm%%ed %%co%%adm%%in %%co%%adm%%filt %%co%%adm%%sh %%co%%adm%%up
# %%adm%%si %%mo%%pic

  helper PicturesHelper

  before_filter :prepare_single, :except => :index

  def edit
    render_edit
  end

  def index
    @pictures=PictureSet.get params[:tag]
    @edit_allowed=true
  end

  def show
    render_show
  end

  def update
    update_picture
    @picture.save :validate => false
    (redirect_back :edit; return) if @picture.invalid?
# TODO: find another way to load the updated picture('s associated tags):
    @picture=Picture.find @picture.id
    render_show
  end

#-------------
  private

  def create_tags(user_tags)
    bad_tags=[]
    (user_tags-(@picture.tags.map &:name)).each do |n|
      (bad_tags << n; next) unless (r=Tag.where :name => n).exists?
      r.all.each{|e| PictureTagJoin.new(:tag_id => e.id, :picture_id =>
          @picture.id).save :validate => false}
    end
    s='Tag nonexistent: '+(bad_tags.join ',')
    flash.now[:notice],flash[:notice]=s,s if bad_tags.present?
  end

  def destroy_tags(user_tags)
    d=@picture.tags.reject{|t| user_tags.include? t.name}.map &:id
    d.each{|i| PictureTagJoin.where(:tag_id => i, :picture_id => @picture.id).
        all.each &:destroy}
  end

  def glom_errors(e)
    e.full_messages.map{|s| s+'.'}.join ' '
  end

  def prepare_single
    @show_filename=true
    (raise ActiveRecord::RecordNotFound) if (pi=params[:id]).blank? || (pi=
        pi.to_i) <= 0
    @picture=Picture.find pi
    @picture.valid?
  end

  def redirect_back(a)
    begin redirect_to :back
    rescue ActionController::RedirectBackError; redirect_to :action => a end
  end

  def render_edit
    @editing=true
    @show_labels=true
    render_single
  end

  def render_show
    @edit_allowed=true
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

  def update_picture
    return unless (pp=params[:picture]).present?
    static = %w[ filename id sequence]
    (%w[description tags title weight year]-static).each do |k|
      next unless pp.has_key? k
      value=pp.fetch k
      unless 'tags'==k
        @picture[k]=value
      else
        a=value.split.uniq
        destroy_tags a
        create_tags a
      end
    end
  end

end
