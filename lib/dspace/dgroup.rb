class DGroup < DSO

  def self.find(name)
    java_import org.dspace.eperson.Group;
    return Group.findByName(Dscriptor.context, name);
  end

  def self.find_or_create(name)
    raise "must give a name " unless name
    group = self.find(name);
    if (group.nil?) then
      group = Group.create(Dscriptor.context);
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
    group = Group.findByName(Dscriptor.context, netid)
    if (not group.nil?)
      puts "deleting #{group}"
      group.delete();
    end
    return group;
  end

  def self.all
    java_import org.dspace.eperson.Group;
    Group.findAll(Dscriptor.context, 1);
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

end
