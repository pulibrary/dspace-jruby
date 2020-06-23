##
# This class wraps an org.dspace.eperson.Group object
class DGroup
  include DSO
  include DDSpaceObject

  ##
  # id of administrator group
  ADMIN_ID = 1

  ##
  # id of anonymous user group
  ANONYMOUS_ID = 0

  ##
  # Collect all Group objects from Dspace context
  # 
  # @return [Array<org.dspace.eperson.Group>]
  def self.all
    java_import org.dspace.eperson.Group;
    Group.findAll(DSpace.context, 1);
  end

  ##
  # Get corresponding Group object from a given id
  #
  # @param name_or_id [String, Integer] the Group id or name
  # @return [nil, org.dspace.eperson.Group] either the corresponding Group 
  #   object or nil if it couldn't be found.
  def self.find(name_or_id)
    java_import org.dspace.eperson.Group;
    if (name_or_id.class == String)
      return Group.findByName(DSpace.context, name_or_id);
    else
      return Group.find(DSpace.context, name_or_id)
    end
  end

  ##
  # Find and return the existing group with the given name or create and return 
  #   a new group with the given name
  #
  # @param name [String] name of new group 
  # @return [org.dspace.eperson.Group] the found or created Group.
  def self.find_or_create(name)
    raise "must give a name " unless name
    group = self.find(name);
    if (group.nil?) then
      group = Group.create(DSpace.context);
      group.setName(name)
      group.update();
      puts "Created #{group.toString()}"
    else
      puts "Exists #{group.toString()}"
    end
    return group;
  end

  ##
  # Get EPerson and Groups that are (direct) members of this Group
  # 
  # @return [Array<org.dspace.eperson.Group, org.dspace.eperson.EPerson>] 
  #   array of members, either Epersons or Groups
  def members
    return  @obj.getMemberGroups.collect { |p| p }  + @obj.getMembers.collect { |p| p }
  end

  ##
  # Add a member to the group
  #
  # @param group_or_eperson [org.dspace.eperson.EPerson, org.dspace.eperson.Group]
  #   must be a  or Group object
  # @return updated self
  def addMember(group_or_eperson)
    raise "must give non nil group_or_eperson" if group_or_eperson.nil?
    @obj.addMember(group_or_eperson);
    @obj.update
    return @obj;
  end

  ##
  # View string representation of object
  # 
  # @return [String] string representation
  def inspect
    return "nil" if @obj.nil?
    return "#<#{self.class.name}:#{@obj.getName}>"  end
end
