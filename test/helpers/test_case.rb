module Compass
  module Fontcustom
    module TestCaseHelper
      module ClassMethods

        def let(method, &block)
          define_method method, &block
        end

        def it(name, &block)
          test(name, &block)
        end

        def test(name, &block)
          define_method "test_#{underscore(name)}".to_sym, &block
        end

        def setup(&block)
          define_method :setup do
            yield
          end
        end

        def after(&block)
          define_method :teardown do
            yield
          end
        end

        private

        def underscore(string)
          string.gsub(' ', '_')
        end

      end
    end
  end
end
