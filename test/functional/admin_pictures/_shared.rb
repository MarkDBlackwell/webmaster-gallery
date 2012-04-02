class SharedAdminPicturesControllerTest < SharedControllerTest
# %%co%%adm

  private

  def assert_flag(*a)
    a.each{|e| assert_present assigns(e), "@#{e} not set."}
  end

  def assert_flash_errors(e=nil)
    if e.blank?
      (r=@record).valid?
      e=r.errors
    end
    assert_equal e.full_messages.map{|s| s+'.'}.join(' '), flash[:error]||''
  end

end
