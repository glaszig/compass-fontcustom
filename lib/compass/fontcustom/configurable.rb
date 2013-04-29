module Compass
  module Fontcustom

    # A simple configuration store like the one known from ActiveSupport.
    module Configurable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def configure(&block)
          yield config
        end

        def config
          @_config ||= Configuration.new
        end
      end

      class Configuration
        def method_missing(meth, *args)
          @config ||= {}
          if meth.to_s =~ /=$/
            sym = meth.to_s[0...-1].to_sym
            @config[sym] = args.first
          else
            @config[meth]
          end
        end
      end

    end
  end
end
