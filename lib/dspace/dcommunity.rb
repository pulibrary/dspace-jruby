##
# This class wraps an org.dspace.content.Community object
class DCommunity
  include DSO
  include DDSpaceObject

  ##
  # return array of all org.dspace.content.Community objects
  def self.all()
    java_import org.dspace.content.Community;
    return Community.findAll(DSpace.context)
  end

  ##
  # returns nil or the org.dspace.content.Community object with the given id
  #
  # id must be an integer
  def self.find(id)
    java_import org.dspace.content.Community;
    return Community.find(DSpace.context, id)
  end

  ##
  #  create and return top level org.dspace.content.Community with given name
  def self.create(name)
    comm = Community.create(nil, DSpace.context)
    comm.setMetadata("name", name)
    comm.update
    return comm
  end

end
