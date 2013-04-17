module Compass
  module Fontcustom
    class Configuration

      @config ||= {}

      def self.method_missing(meth, *args)
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
