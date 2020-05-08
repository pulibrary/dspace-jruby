###
# This class wraps an org.dspace.content.Bitstream object
class DBitstream
  include DSO
  include DDSpaceObject

  ##
  # Collect all Bitstream objects from Dspace context
  # 
  # @return [Array<org.dspace.content.Bitstream>]
  def self.all()
    java_import org.dspace.content.Bitstream;
    return Bitstream.findAll(DSpace.context)
  end

  ##
  # Get corresponding Bitstream object from a given id
  #
  # @param id [Integer] the Bitstream id
  # @return [nil, org.dspace.content.Bitstream] either the corresponding 
  #   bitstream object or nil if it couldn't be found.
  def self.find(id)
    java_import org.dspace.content.Bitstream;
    return Bitstream.find(DSpace.context, id)
  end

end
