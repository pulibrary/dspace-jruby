# frozen_string_literal: true

module DSpace # rubocop:disable Style/Documentation
  # Module containing the functionality for issuing deprecation warnings
  module Deprecation
    module ClassMethods # rubocop:disable Style/Documentation
      def deprecation_horizon
        '1.0.0'
      end

      def deprecated_method_warning(method_name, message = nil)
        warning = "#{method_name} is deprecated and will be removed from #{name} #{deprecation_horizon}"
        case message
        when Symbol
          "#{warning} (use #{message} instead)"
        when String
          "#{warning} (#{message})"
        else
          warning
        end
      end

      def warn_deprecated(method_name, message = nil, _callstack = nil)
        warning = deprecated_method_warning(method_name, message)
        logger.warn(warning)
      end
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end
end
