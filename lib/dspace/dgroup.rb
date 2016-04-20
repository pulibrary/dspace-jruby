class DGroup
  include DSO

  ADMIN_ID = 1;
  ANONYMOUS_ID = 0;

  def self.all
    java_import org.dspace.eperson.Group;
    Group.findAll(DSpace.context, 1);
  end

  def self.find(name_or_id)
    java_import org.dspace.eperson.Group;
    if (name_or_id.class == String)
      return Group.findByName(DSpace.context, name_or_id);
    else
      return Group.find(DSpace.context, name_or_id)
    end
  end

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

  def members
    list = [];
    @dso.getMembers.each do |m|
      list << m;
    end
    @dso.getMemberGroups.each do |m|
      list << m;
    end
    return list;
  end

  def addMember(addGrouNameOrNetid)
    add = DGroup.find(addGrouNameOrNetid)
    if (add.nil?) then
        add = DEPerson.find(addGrouNameOrNetid);
    end 
    raise "no such netid or group #{addGrouNameOrNetid}" if add.nil?
    @dso.addMember(add);
    @dso.update
    return @dso;
  end

  def report
    rpt = dso_report
    @obj.getMemberGroups.each do |m|
      rpt[m.toString] = DGroup.new(m).report
    end
    list = @obj.getMembers()
    rpt['epersons'] = list.collect { |p| DEerson.new(p).report  } unless list.empty?
    return rpt;
  end

end
