##
# This class wraps an org.dspace.content.Collection object
class DCollection
  include DSO

  ##
  # return array of all org.dspace.content.Collection objects
  def self.all()
    java_import org.dspace.content.Collection;
    return Collection.findAll(DSpace.context)
  end

  ##
  # returns nil or the org.dspace.content.Collection object with the given id
  #
  # id must be an integer
  def self.find(id)
    java_import org.dspace.content.Collection;
    return Collection.find(DSpace.context, id)
  end

end
