###
# This class wraps an org.dspace.content.Bundle object
class DBundle
  include DSO
  include DDSpaceObject

  ##
  # Get corresponding Bundle object from a given id
  #
  # @param id [Integer] the Bundle id
  # @return [nil, org.dspace.content.Bundle] either the corresponding bundle 
  #   object or nil if it couldn't be found.
  def self.find(id)
    java_import org.dspace.content.Bundle;
    return Bundle.find(DSpace.context, id)
  end
end