###
# This class wraps an org.dspace.content.Bitstream object
class DBundle
  include DSO
  include DDSpaceObject

  ##
  # returns nil or the org.dspace.content.Bundle object with the given id
  #
  # id must be an integer
  def self.find(id)
    java_import org.dspace.content.Bundle;
    return Bundle.find(DSpace.context, id)
  end
end