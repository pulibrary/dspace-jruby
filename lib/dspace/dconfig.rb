##
# This class wraps an org.dspace.core.ConfigurationManager object
class DConfig

  ##
  # Get configuration property
  # 
  # @param name [String] name of the property
  # @return [nil, String] value for name or nil if it does not exist
  def self.get(name)
    java_import org.dspace.core.ConfigurationManager;
    ConfigurationManager.getProperty name
  end
end