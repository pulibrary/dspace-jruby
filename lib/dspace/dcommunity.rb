##
# This class wraps an org.dspace.content.Community object
class DCommunity
  include DSO

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

end
