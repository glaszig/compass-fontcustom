require 'test/unit'
require 'compass/fontcustom'
require 'helpers/test_case'

class Test::Unit::TestCase
	extend Compass::Fontcustom::TestCaseHelper::ClassMethods
end