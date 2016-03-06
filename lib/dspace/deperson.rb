class DEPerson
  include DSO

  def self.all()
    java_import org.dspace.eperson.EPerson;
    return EPerson.findAll(DSpace.context, 1)
  end

  def self.create(netid, first, last)
    java_import org.dspace.eperson.EPerson;
    raise "must give a netid value" unless netid
    raise "must give a first and last name" unless (first and last)
    p = EPerson.findByNetid(DSpace.context, netid)
    raise "netid #{netid} already in use" unless p.nil?

    @dso = EPerson.create(DSpace.context)
    @dso.first_name = first;
    @dso.last_name = last;
    @dso.netid = netid;
    @dso.email = "#{netid}@princeton.edu";
    @dso.canLogIn = true;
    @dso.update;
    puts "Created #{@dso}"
    return @dso;
  end

  def self.find(netid_or_email)
    java_import org.dspace.eperson.EPerson;
    raise "must give a netid_or_email value" unless netid_or_email
    return EPerson.findByNetid(DSpace.context, netid_or_email) || EPerson.findByEmail(DSpace.context, netid_or_email)
  end

  def groups
    java_import org.dspace.eperson.Group;
    return Group.allMemberGroups(DSpace.context, @obj);
  end

  def group_names
    groups.collect { |g| g.getName}.sort
  end

end
