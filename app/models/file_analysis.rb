class FileAnalysis

  def approval_group
    @approval_group
  end

  def approval_needed?
    safe=review_messages.values_at(0,4,5)
    a=@review_groups.reject{|e| safe.include? e.message}
    @approval_group.list      .present? ||
    a.map(&        :list).to_s.present?
  end

  def initialize
    @review_groups, @approval_group = get_groups
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
      @approval_group.list.split.each{|e| model.create method.to_sym => e}
    when 1
      model.where(["#{method} IN (?)", @approval_group.list.split]).all.
          each{|e| e.destroy}
    end
    true
  end

  def review_groups
    @review_groups
  end

  def review_messages
    [
        'Tags in file:',
        'Bad tag names in file:',
        'Bad picture names in directory:',
        'Unpaired pictures in directory:',
        'Existing pictures:',
        'Pictures in directory:',
        ]
  end

#-------------
  private

  def get_groups
    s=:name
         tn = ( t =        Tag.order(s).find :all).map &s
    file_tn =          FileTag         .find(:all).map(&s).sort
    s=:filename
         pn = ( p =    Picture.order(s).find :all).map &s
    file_pn = DirectoryPicture         .find(:all).map(&s).sort
    s=nil
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
    review=[    s.new(file_tn,  rm.shift),
                s.new(ft_bad_n, rm.shift)]
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
                s.new(unpaired, rm.shift),
                s.new(p,        rm.shift),
                s.new(file_pn,  rm.shift)] unless 0==model_i
# TODO: maybe only p and file_pn unless 0==model_i
      if (a=records || names).present?
        m = %w[ Tag Picture ].at     model_i
        o = %w[ add delet   ].at operation_i
        review << s.new( a, "#{m}s to be #{o}ed:")
        approval= s.new((names.sort.join ' '), "approve #{o}ing #{m.downcase}s")
      end
    end
    [review, approval]
  end

end
