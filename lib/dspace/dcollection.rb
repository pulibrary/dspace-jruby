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

  ##
  #  create and return org.dspace.content.Collection with given name in the given community
  #
  # community must be a org.dspace.content.Communiy obj
  def self.create(name, community)
    java_import org.dspace.content.Collection;
    new_col = Collection.create(DSpace.context)
    new_col.setMetadata("name", name)
    new_col.update
    community.addCollection(new_col)
    return new_col
  end

  ##
  # return all items listed by the dspace item iterator
  def items
    items, iter  = [], @obj.items
    while (i = iter.next) do
      items << i
    end
    items
  end
end
