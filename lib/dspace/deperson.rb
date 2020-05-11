##
# This class wraps an org.dspace.eperson.EPerson object
class DEPerson
  include DSO
  include DDSpaceObject

  ##
  # Collect all Eperson objects from Dspace context
  # 
  # @return [Array<org.dspace.eperson.Eperson>]
  def self.all()
    java_import org.dspace.eperson.EPerson;
    return EPerson.findAll(DSpace.context, 1)
  end

  ##
  # Find the EPerson object from netid, email, or id
  #
  # @param netid_email_or_id [String, Integer] the netid (String), email 
  #   (String), or id (Integer) to search with
  # @return [org.dspace.eperson.EPerson, nil] the corresponding object or nil if
  #   it could not be found
  def self.find(netid_email_or_id)
    java_import org.dspace.eperson.EPerson;
    raise "must give a netid_or_email value" unless netid_email_or_id
    if netid_email_or_id.is_a? String then
      # ?? these functions are elsewhere
      return EPerson.findByNetid(DSpace.context, netid_email_or_id) || EPerson.findByEmail(DSpace.context, netid_email_or_id)
    end
    return EPerson.find(DSpace.context, netid_email_or_id)
  end

  ##
  # Create an org.dspace.eperson.EPerson with the given netid, name and email.
  #   The EPerson is not committed to the database.
  # 
  # @param netid [String] institutional netid
  # @param first [String] first name
  # @param last [String] last name
  # @param email [String] email address
  # @return [org.dspace.eperson.EPerson] the newly created person
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
  # Return all groups where this user is a member
  # 
  # @return [Array<org.dspace.eperson.Group>] Array of groups
  def groups
    java_import org.dspace.eperson.Group;
    return Group.allMemberGroups(DSpace.context, @obj);
  end

  ##
  # View string representation
  # 
  # @return [String] person object represented as a string
  def inspect
    return "nil" if @obj.nil?
    describe = @obj.getNetid || @obj.getEmail || @obj.getID
    return "#<#{self.class.name}:#{describe}>"
  end
end
