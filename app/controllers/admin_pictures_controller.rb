class AdminPicturesController < ApplicationController
# %%co%%adm%%ed %%co%%adm%%in %%co%%adm%%filt %%co%%adm%%sh %%co%%adm%%up
# %%adm%%si %%mo%%pic

# working on

  helper PicturesHelper
  before_filter :prepare_single, :except => :index

  def edit
    render_edit
  end

  def index
    @editable=true
    r=Picture.order 'weight, year DESC, sequence DESC'
    tag=params[:tag]
    r=r.joins(:tags).where :tags => {:name => tag} if tag
    @pictures=r.all
  end

  def show
    render_show
  end

  def update
    if (p=params[:picture]).present?
      r=@picture
      static = %w[ filename id sequence]
      (%w[description title weight year]-static).each do |e|
        next unless p.has_key? e
        r[e]=p.fetch e
      end
      if p.has_key?(t='tags')
        pt=p.fetch(t).split.uniq
        destroy_tags=r.tags.reject{|e| pt.include? e.name}
        rn=r.tags.map &:name
        create_tags=pt.reject{|e| rn.include? e}.map{|e| Tag.find_by_name e}
        destroy_tags.map(&:id).each do |e|
          c=PictureTagJoin.where(:tag_id => e, :picture_id => r.id).all
          c.each{|j| j.destroy}
        end
        create_tags.map(&:id).each do |e|
          j=PictureTagJoin.create :tag_id => e, :picture_id => r.id
          j.save :validate => false
        end
      end
      r.save :validate => false
    end
    (redirect_back :edit; return) if r.invalid?
# TODO: find another way to load the updated record (tags):
    @picture=Picture.find r.id
    render_show
  end

#-------------
  private

  def glom_errors(e)
    e.full_messages.map{|s| s+'.'}.join ' '
  end

  def prepare_single
    @show_filename=true
    (@picture=Picture.find params[:id]).valid?
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
