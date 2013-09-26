module Compass
  module Fontcustom

    class FontImporter
      def self.search_paths
        Rails.application.config.assets.paths
      end
    end

  end
end
