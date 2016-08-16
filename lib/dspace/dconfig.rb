##
# This class wraps an org.dspace.content.Community object
class DConfig

  ##
  # return configuration value for name
  def self.get(name)
    java_import org.dspace.core.ConfigurationManager;
    ConfigurationManager.getProperty name
  end
end