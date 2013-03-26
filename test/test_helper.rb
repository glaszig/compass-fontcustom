require 'test/unit'
require 'compass/fontcustom'
require 'helpers/test_case'
require 'pry'

class Test::Unit::TestCase
	extend Compass::Fontcustom::TestCaseHelper::ClassMethods
end