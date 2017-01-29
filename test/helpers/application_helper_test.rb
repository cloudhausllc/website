require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'should create a basic glyphicon' do
    glyph = glyph('ok')
    assert_equal glyph, '<span class="glyphicon glyphicon-ok"></span>'
  end
end