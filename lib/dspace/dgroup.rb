class DGroup < DSO

  def self.find(name)
    java_import org.dspace.eperson.Group;
    return Group.findByName(DSpace.context, name);
  end

  def self.find_or_create(name)
    raise "must give a name " unless name
    group = self.find(name);
    if (group.nil?) then
      group = Group.create(DSpace.context);
      group.setName(group)
      group.update();
      puts "Created #{group.toString()}"
    else
      puts "Exists #{group.toString()}"
    end
    return group;
  end

  def self.delete(name)
    java_import org.dspace.eperson.Group;
    group = Group.findByName(DSpace.context, netid)
    if (not group.nil?)
      puts "deleting #{group}"
      group.delete();
    end
    return group;
  end

  def self.all
    java_import org.dspace.eperson.Group;
    Group.findAll(DSpace.context, 1);
  end

  def self.members(name)
    group = self.find(name);
    list = [];
    group.getMembers.each do |m|
      list << m;
    end
    group.getMemberGroups.each do |m|
      list << m;
    end
    return list;
  end

  def self.addMember(name, addGrouNameOrNetid)
    group = DGroup.find(name);
    raise "no such group #{name}" if group.nil?
    add = DGroup.find(addGrouNameOrNetid)
    if (add.nil?) then
        add = DEPerson.find(addGrouNameOrNetid);
    end 
    raise "no such netid or group #{addGrouNameOrNetid}" if add.nil?
    group.addMember(add);
    group.update
    return group;
  end

  def self.report(dso)
    rpt = DSO.report(dso)
    if (not dso.nil?) then
      members = dso.getMemberGroups();
      members.each do |m|
           rpt[m.toString] = DGroup.report(m)
      end
      members = dso.getMembers();
      if (not members.empty?) then
          rpt['epersons'] = members.collect { |p| p.netid }
      end
    end
    return rpt;
  end

end
