class DEPerson < DSO

  def self.create(netid, first, last)
    java_import org.dspace.eperson.EPerson;
    raise "must give a netid value" unless netid
    raise "must give a first and last name" unless (first and last)
    p = EPerson.findByNetid(Dscriptor.context, netid)
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

  def self.groups(eperson_or_string)
    java_import org.dspace.eperson.EPerson;
    java_import org.dspace.eperson.Group;
    if (eperson_or_string.class == String) then
       p = find(eperson_or_string)
       if (p.nil?) then
         p = DSO.fromString(eperson_or_string);
       end
     else
       p = eperson_or_string
     end
     return Group.allMemberGroups(DSpace.context, p);
  end

  def self.find(netid)
    java_import org.dspace.eperson.EPerson;
    raise "must give a netid value" unless netid
    return  EPerson.findByNetid(DSpace.context, netid)
  end

  def self.delete(netid)
    java_import org.dspace.eperson.EPerson;
    @dso = EPerson.findByNetid(DSpace.context, netid)
    if (not @dso.nil?)
      puts "deleting #{@dso}"
      @dso.delete();
    end
    return @dso;
  end



end