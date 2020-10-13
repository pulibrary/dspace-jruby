# frozen_string_literal: true

module DSpace
  module Core
    # This class wraps an org.dspace.core.ConfigurationManager object
    class Config
      java_import(org.dspace.core.ConfigurationManager)

      # Get configuration property
      #
      # @param name [String] name of the property
      # @return [nil, String] value for name or nil if it does not exist
      def self.get(name)
        ConfigurationManager.getProperty name
      end
    end
  end
end
