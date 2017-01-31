module Compass
  module Fontcustom
    module Deprecations
      def fontcustom_fonts_path= value
        warn "WARNING: fontcustom_fonts_path is deprecated. Prefer to use Compass' fonts_path."
        super
      end

      [ Compass::Configuration::FileData,
        Compass::Configuration::Data
      ].each do |m|
        m.send :include, Deprecations
      end
    end
  end
end
