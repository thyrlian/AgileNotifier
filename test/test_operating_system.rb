require_relative 'helper'
require_relative 'ext/module'

class TestOperatingSystem < Test::Unit::TestCase
  def test_is_mac?
    Object.stub_const_and_test(:RUBY_PLATFORM, 'x86_64-darwin11.2.0') { assert_equal(true, OperatingSystem.is_mac?) }
  end

  def test_is_linux?
    Object.stub_const_and_test(:RUBY_PLATFORM, 'x86_64-linux') { assert_equal(true, OperatingSystem.is_linux?) }
  end

  def test_is_windows?
    Object.stub_const_and_test(:RUBY_PLATFORM, 'i386-mingw32') { assert_equal(true, OperatingSystem.is_windows?) }
  end
end