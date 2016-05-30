##
# This class wraps an org.dspace.eperson.Group object
class DGroup
  include DSO

  ##
  # id of administrator group
  ADMIN_ID = 1

  ##
  # id of anonymous user group
  ANONYMOUS_ID = 0

  ##
  # return array of all org.dspace.eperson.Group objects
  def self.all
    java_import org.dspace.eperson.Group;
    Group.findAll(DSpace.context, 1);
  end

  ##
  # returns nil or the org.dspace.eperson.Group object with the given name or id
  # name_or_id: must be a string or integer
  def self.find(name_or_id)
    java_import org.dspace.eperson.Group;
    if (name_or_id.class == String)
      return Group.findByName(DSpace.context, name_or_id);
    else
      return Group.find(DSpace.context, name_or_id)
    end
  end

  ##
  # find and return the existing group with the given name or create and return a new group with the given name
  #
  # name must be a string
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
  # return EPerson and Groups that are (direct) require 'faker;members of this DGroup
  #
  # name must be a string
  def members
    return @obj.getMembers + @obj.getMemberGroups
  end

  ##
  # add a memeber to the group
  #
  # group_or_eperson must be a org.dspace.eperson.EPerson or Group object
  def addMember(group_or_eperson)
    raise "must give non nil group_or_eperson" if group_or_eperson.nil?
    @obj.addMember(group_or_eperson);
    @obj.update
    return @obj;
  end

  ##
  # convert to string
  def inspect
    return "GROUP.#{@obj.getName}"
  end
end
