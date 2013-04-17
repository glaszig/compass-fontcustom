module Compass
  module Fontcustom
    module Configurable

      def self.included(base)
        base.class_eval do
          def self.configure(&block)
            yield config
          end

          def self.config
            @_config ||= Configuration.new
          end
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
