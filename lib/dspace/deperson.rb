##
# This class wraps an org.dspace.eperson.EPerson object
class DEPerson
  include DSO
  include DDSpaceObject

  ##
  # return array of all org.dspace.eperson.EPerson objects
  def self.all()
    java_import org.dspace.eperson.EPerson;
    return EPerson.findAll(DSpace.context, 1)
  end

  ##
  # returns nil or the org.dspace.eperson.EPerson object with the given netid, email, or id
  # netid_or_email: must be a string or integer
  def self.find(netid_email_or_id)
    java_import org.dspace.eperson.EPerson;
    raise "must give a netid_or_email value" unless netid_email_or_id
    if netid_email_or_id.is_a? String then
      return EPerson.findByNetid(DSpace.context, netid_email_or_id) || EPerson.findByEmail(DSpace.context, netid_email_or_id)
    end
    return EPerson.find(DSpace.context, netid_email_or_id)
  end

  ##
  # create an org.dspace.eperson.EPerson with the given netid, name and email
  #
  # the EPerson is not committed to the database
  def self.create(netid, first, last, email)
    java_import org.dspace.eperson.EPerson;
    raise "must give a netid value" unless netid
    raise "must give a first and last name" unless (first and last)
    p = EPerson.findByNetid(DSpace.context, netid)
    raise "netid #{netid} already in use" unless p.nil?

    @dso = EPerson.create(DSpace.context)
    @dso.first_name = first;
    @dso.last_name = last;
    @dso.netid = netid;
    @dso.email = email
    @dso.canLogIn = true;
    @dso.update;
    puts "Created #{@dso}"
    return @dso;
  end

  ##
  # return all groups where this user is a member
  def groups
    java_import org.dspace.eperson.Group;
    return Group.allMemberGroups(DSpace.context, @obj);
  end

  ##
  # convert to string
  def inspect
    return "nil" if @obj.nil?
    describe = @obj.getNetid || @obj.getEmail || @obj.getID
    return "#<#{self.class.name}:#{describe}>"
  end
end
