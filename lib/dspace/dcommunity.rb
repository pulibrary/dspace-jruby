##
# This class wraps an org.dspace.content.Community object
class DCommunity
  include DSO
  include DDSpaceObject

  ##
  # Collect all Community objects from Dspace context
  # 
  # @return [Array<org.dspace.content.Community>]
  def self.all()
    java_import org.dspace.content.Community;
    return Community.findAll(DSpace.context)
  end

  ##
  # Get corresponding Community object from a given id
  #
  # @param id [Integer] the Community id
  # @return [nil, org.dspace.content.Community] either the corresponding 
  #   Community object or nil if it couldn't be found.
  def self.find(id)
    java_import org.dspace.content.Community;
    return Community.find(DSpace.context, id)
  end

  ##
  # Create and return org.dspace.content.Community with given name in the given 
  #   community
  #
  # @param name [String] the name of the new Community
  # @return [org.dspace.content.Community] the newly created Community
  def self.create(name)
    comm = Community.create(nil, DSpace.context)
    comm.setMetadata("name", name)
    comm.update
    return comm
  end

  # ??
  ##
  # Get collections within community.
  # 
  # @return [Array<org.dspace.content.Collection>]
  def getCollections
     return DCommunity.getCollections(self.dso)
  end

  ##
  # Get all collections from within given community and subcommunities
  #
  # @param com [org.dspace.content.Community]
  # @return [Array<org.dspace.content.Collection>]
  def self.getCollections(com)
      colls = []
      if (not com.is_a? Array) then
        com = [com]
      end
      com.each do |c|
        colls = colls + c.getCollections.collect { |c| c }
        colls = colls + getCollections(c.getSubcommunities.collect{ |sc| sc })
      end
      return colls
    end
end
