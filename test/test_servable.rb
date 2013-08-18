require_relative 'helper'

class TestServable < Test::Unit::TestCase
  def setup
    @obj = Servable::PrivateMethods.new
  end
  
  def test_is_https_request
    assert_equal(true, @obj.is_https_request?('https://example.com/'))
  end
  
  def test_is_not_https_request
    assert_equal(false, @obj.is_https_request?('http://example.com/'))
  end
end