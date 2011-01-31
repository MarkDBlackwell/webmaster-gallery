require 'test_helper'

class AppTest < ActiveSupport::TestCase
# %%mo%%app

  test "..." do
# Sessions should expire after a duration of inactivity:
    assert_equal 20.minutes, App.session_options.fetch(:expire_after)
# Webmaster directory location should be configured:
    assert_equal App.webmaster, (App.root.join *%w[
        test  fixtures  files  webmaster  ])
  end

end
