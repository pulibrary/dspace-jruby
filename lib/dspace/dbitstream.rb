###
# This class wraps an org.dspace.content.Bitstream object
class DBitstream
  include DSO

  ##
  # return array of all org.dspace.content.Bitstream objects
  def self.all()
    java_import org.dspace.content.Bitstream;
    return Bitstream.findAll(DSpace.context)
  end

  ##
  # returns nil or the org.dspace.content.Bitstream object with the given id
  # id:: must be an integer
  def self.find(id)
    java_import org.dspace.content.Bitstream;
    return Bitstream.find(DSpace.context, id)
  end

end
