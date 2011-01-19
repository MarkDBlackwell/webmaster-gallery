class FileAnalysis
# %%mo%%fan

  attr_reader :approval_group, :review_groups

  def approval_needed?
    safe=review_messages.values_at(*safe_at=[])
    a=@review_groups.reject{|e| safe.include? e.message}
    @approval_group.list      .present? ||
            a.map(&:list).to_s.present?
  end

  def files_invalid?
    models = %w[ FileTag    DirectoryPicture ]
    models.map{|m| m.constantize.find(:all).select{|e| e.invalid?}}.flatten.
        present?
  end

  def initialize
    @review_groups,@approval_group=get_groups
  end

  def make_changes
    return false if @approval_group.blank? || @approval_group.list.blank? ||
                     @review_groups.blank? || @review_groups.last.blank? ||
                                              @review_groups.last.message.blank?
    models     = %w[ Tag Picture]
    operations = %w[ add delet  ]
    model_i,operation_i=(two_states=[0,1]).product(two_states).
        detect{ |m,o| "#{ models.at m }s "\
        "to be #{     operations.at o }ed:" == @review_groups.last.message}
    return false if model_i.blank? || operation_i.blank?
    model=models.at(model_i).constantize
    method = %w[name filename].at model_i
    case operation_i
    when 0
      @approval_group.list.split.each{|e| model.send('find_or_create_by_'+
          method, e).save :validate => false}
    when 1
      model.where(["#{method} IN (?)", @approval_group.list.split]).all.
          each{|e| e.destroy}
      if 1==model_i
        m=model.order(method).all
        f=DirectoryPicture.find(:all).sort{|a,b| a.filename<=>b.filename}
        f.length.times{|i| m[i].sequence=f.at(i).sequence}
        m.each{|e| e.save :validate => false}
      end
    end
    true
  end

  def review_messages
    [
        'Bad tag names in file:',
        'Bad picture names in directory:',
        'Unpaired pictures in directory:',
        ]
  end

#-------------
  private

  def get_groups
    n=:name
         tn = ( t =        Tag.order(n).find :all).map &n
    file_tn =          FileTag         .find(:all).map(&n).sort
    n=:filename
         pn = ( p =    Picture.order(n).find :all).map &n
    file_pn = DirectoryPicture         .find(:all).map(&n).sort
    n=nil
    model_i,operation_i=case
    when (names=file_tn-tn).present?
      [0,0]
    when (names=tn-file_tn).present?
      records=    Tag.order(    :name).where([    "name IN (?)", names]).all
      [0,1]
    when (names=file_pn-pn).present?
      [1,0]
    when (names=pn-file_pn).present?
      records=Picture.order(:filename).where(["filename IN (?)", names]).all
      [1,1]
    else names=[]
      [nil,nil]
    end
    ft_bad_n=FileTag         .find_bad_names.sort
    fp_bad_n=DirectoryPicture.find_bad_names.sort
    unpaired=DirectoryPicture.find_unpaired_names.sort
    s=Struct.new :list, :message
    approval=s.new '', 'refresh'
    rm=review_messages
    review=[    s.new(ft_bad_n, rm.shift)]
    case
    when ft_bad_n.present?
    when fp_bad_n.present?
      review << s.new(fp_bad_n, rm.shift)
    when unpaired.present?
      review.concat [
                s.new(fp_bad_n, rm.shift),
                s.new(unpaired, rm.shift)]
    else
      review.concat [
                s.new(fp_bad_n, rm.shift),
                s.new(unpaired, rm.shift)] unless 0==model_i
# TODO: maybe only p and file_pn unless 0==model_i
      if (a=records || names).present?
        m = %w[ Tag Picture ].at     model_i
        o = %w[ add delet   ].at operation_i
        review << s.new( a, "#{m}s to be #{o}ed:")
        approval= s.new names.sort.join(' '), "approve #{o}ing #{m.downcase}s"
      end
    end
    [review, approval]
  end

end
